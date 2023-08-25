#!/bin/bash

# Update repositories
sudo yum update -y
sudo dnf update

# Install Apache
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
# install Git
sudo yum install git -y

# Install Java & Scala
sudo dnf install java-11-amazon-corretto -y
sudo dnf install java-11-amazon-corretto-devel -y
# sudo yum install -y java-11-openjdk-headless
wget https://downloads.lightbend.com/scala/2.13.11/scala-2.13.11.rpm
sudo rpm -Uvh scala-2.13.11.rpm
rm scala-2.13.11.rpm

# Install firewalld
sudo yum install -y firewalld
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-port=3000/tcp --permanent
sudo firewall-cmd --zone=public --add-port=53/tcp --permanent
sudo firewall-cmd --zone=public --add-port=22/tcp --permanent
sudo firewall-cmd --zone=public --add-port=43/tcp --permanent
sudo firewall-cmd --reload




# Install Grafana
wget https://dl.grafana.com/oss/release/grafana-10.0.3-1.x86_64.rpm
sudo yum localinstall -y grafana-10.0.3-1.x86_64.rpm
rm grafana-10.0.3-1.x86_64.rpm
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
grafana-cli --version

# Install Grafana plugins
grafana-cli plugins install grafana-piechart-panel
sudo systemctl restart grafana-server

# Install yesoreyeram-boomtable-panel
grafana-cli plugins install yesoreyeram-boomtable-panel
sudo systemctl restart grafana-server
