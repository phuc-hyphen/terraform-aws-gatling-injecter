variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 intance type"
}
variable "access_key" {
  type        = string
  default     = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  description = "Access key to AWS"
}
variable "secret_key" {
  type        = string
  default     = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  description = "Secret key to AWS"
}

variable "availability_zone" {
  type        = string
  default     = "us-east-1a"
  description = "EC2 availability zone"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "EC2 region zone"
}


variable "key-main-path" {
  type        = string
  default     = "../credentials/main-key.pem"
  description = "path to main key "
}


