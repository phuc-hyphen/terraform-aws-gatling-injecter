#!/bin/bash

# Install Gatling
wget https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/3.9.5/gatling-charts-highcharts-bundle-3.9.5-bundle.zip
unzip gatling-charts-highcharts-bundle-3.9.5-bundle.zip
rm gatling-charts-highcharts-bundle-3.9.5-bundle.zip
mv gatling-charts-highcharts-bundle-3.9.5 gatling-bundle
sudo chmod -R 777 gatling-bundle

# Install InfluxDB
# influxdata-archive_compat.key GPG fingerprint:
#     9D53 9D90 D332 8DC7 D6C8 D3B9 D8FF 8E1F 7DF8 B07E
cat <<EOF | sudo tee /etc/yum.repos.d/influxdata.repo
[influxdata]
name = InfluxData Repository - Stable
baseurl = https://repos.influxdata.com/stable/\$basearch/main
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdata-archive_compat.key
EOF

sudo yum install -y influxdb

mv -f configs/configs/gatling.conf configs/configs/logback.xml gatling-bundle/conf/
sudo mv -f configs/configs/influxdb.conf /etc/influxdb/

sudo systemctl start influxdb
sudo systemctl enable influxdb