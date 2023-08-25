#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo bash -c 'echo not found'
# install scala
sudo apt-get install -y openjdk-11-jre-headless 
wget https://downloads.lightbend.com/scala/2.13.11/scala-2.13.11.deb
sudo dpkg -i scala-2.13.11.deb
rm scala-2.13.11.deb


# install fireawalld
sudo apt-get install -y firewalld
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-port=3000/tcp --permanent
sudo firewall-cmd --zone=public --add-port=53/tcp --permanent
sudo firewall-cmd --zone=public --add-port=22/tcp --permanent
sudo firewall-cmd --zone=public --add-port=43/tcp --permanent
sudo firewall-cmd --reload

# install gatling 
sudo apt install -y unzip
wget https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/3.9.5/gatling-charts-highcharts-bundle-3.9.5-bundle.zip
unzip gatling-charts-highcharts-bundle-3.9.5-bundle.zip
rm gatling-charts-highcharts-bundle-3.9.5-bundle.zip
mv gatling-charts-highcharts-bundle-3.9.5 gatling-bundle
sudo chmod -R 777 gatling-bundle
mv gatling-bundle /home/ec2-user/

# install influxdb 
# wget https://dl.influxdata.com/influxdb/releases/influxdb2-2.0.9-linux-amd64.tar.gz
# tar xvzf influxdb2-2.0.9-linux-amd64.tar.gz
# sudo cp influxdb2-2.0.9-linux-amd64/{influx,influxd} /usr/local/bin/
# rm influxdb2-2.0.9-linux-amd64.tar.gz
# rm -r influxdb2-2.0.9-linux-amd64

sudo apt-get install influxdb
sudo systemctl start influxdb
sudo systemctl enable influxdb

# install grafana 
wget https://dl.grafana.com/oss/release/grafana_10.0.3_amd64.deb
sudo dpkg -i grafana_10.0.3_amd64.deb
rm grafana_10.0.3_amd64.deb
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
grafana-cli --version

# install grafana-plugin 
# piechart-panel 
# wget -nv https://grafana.com/api/plugins/grafana-piechart-panel/versions/latest/download -O /tmp/grafana-piechart-panel.zip
# unzip -q /tmp/grafana-piechart-panel.zip -d /tmp
# sudo rm /tmp/grafana-piechart-panel.zip
# sudo mv /tmp/grafana-piechart-panel* /var/lib/grafana/plugins/grafana-piechart-panel
grafana-cli plugins install grafana-piechart-panel
cd /var/lib/grafana/plugins
sudo chown -R grafana:grafana grafana-piechart-panel
cd ~
sudo systemctl restart grafana-server

# yesoreyeram-boomtable-panel
grafana-cli plugins install yesoreyeram-boomtable-panel
sudo systemctl restart grafana-server




