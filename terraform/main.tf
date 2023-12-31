provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
# 1. Create vpc

resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}

# 2. Create Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id


}
# 3. Create Custom Route Table

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Prod"
  }
}

# 4. Create a Subnet 

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "prod-subnet"
  }
}

# 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}
# 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web https and ssh traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

# 7. Create a network interface with an ip in the subnet that was created in step 4

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}
# 8. Assign an elastic IP to the network interface created in step 7

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw, aws_network_interface.web-server-nic, aws_instance.gatling-injecter-instance]

}



# 9. Create Ubuntu server and install/enable apache2
resource "aws_instance" "gatling-injecter-instance" {
  ami               = "ami-07e67bd6b5d9fd892"
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  key_name          = "main-key"
  depends_on        = [aws_network_interface.web-server-nic]

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = file("../bash/install-base-ec2.sh")
  tags = {
    Name = "web-server"
  }

}
output "dns" {
  value = aws_eip.one.public_dns
}
output "server_public_ip" {
  value = aws_eip.one.public_ip
}
# output "server_private_ip" {
#   value = aws_instance.gatling-injecter-instance.private_ip
# }
output "grafana_url" {
  value = "http://${aws_eip.one.public_dns}:3000"
}
# output "server_id" {
#   value = aws_instance.gatling-injecter-instance.id
# }

resource "null_resource" "create-config" {
  # depends_on = [aws_instance.gatling-injecter-instance, null_resource.upload-file-configs]

  provisioner "local-exec" {
    # command     = "pwd"
    command     = "powershell Compress-Archive ../configs/ configs.zip -Update"
    interpreter = ["PowerShell", "-Command"]

  }
}


resource "null_resource" "upload-file-configs" {
  # depends_on = [aws_instance.gatling-injecter-instance]
  depends_on = [null_resource.create-config]

  provisioner "file" {
    source      = "configs.zip"
    destination = "configs.zip"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.key-main-path)
      host        = aws_eip.one.public_ip
      port        = 22
    }
  }

}


resource "null_resource" "add-config" {
  depends_on = [null_resource.upload-file-configs]

  provisioner "remote-exec" {
    inline = [
      # "sudo yum -y install tree",
      # "pwd",
      # "ls",
      "unzip configs.zip",
      "sudo yum install -y dos2unix",
      "dos2unix ./configs/install-influxdb-gatling-ec2.sh",
      "sudo chmod 777 configs/install-influxdb-gatling-ec2.sh",
      "tree",
      "./configs/install-influxdb-gatling-ec2.sh",
      "rm -r configs.zip"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.key-main-path)
      host        = aws_eip.one.public_ip
    }
  }
}

