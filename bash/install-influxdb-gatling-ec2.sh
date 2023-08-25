#!/bin/bash



# Install Gatling
wget https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/3.9.5/gatling-charts-highcharts-bundle-3.9.5-bundle.zip
unzip gatling-charts-highcharts-bundle-3.9.5-bundle.zip
rm gatling-charts-highcharts-bundle-3.9.5-bundle.zip
mv gatling-charts-highcharts-bundle-3.9.5 gatling-bundle
sudo chmod -R 777 gatling-bundle
mv gatling-bundle /home/ec2-user/

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
sudo systemctl start influxdb
sudo systemctl enable influxdb


# unzip injecter-configs.zip
# mv injecter-configs/gatling.conf injecter-configs/logback.xml gatling-bundle/conf/
# sudo mv injecter-configs/influxdb.conf /etc/influxdb/
# rm -r injecter-configs injecter-configs.zip
# export INFLUXD_CONFIG_PATH="/etc/influxdb/influxdb.conf"
# sudo systemctl restart influxdb
