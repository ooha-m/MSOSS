#!/bin/bash

sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo apt-get -y install oracle-java8-installer
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
sudo apt-get update
sudo apt-get -y install elasticsearch
sed -i 's/#network.host: 192.168.0.1/network.host: localhost/g' /etc/elasticsearch/elasticsearch.yml
sudo systemctl restart elasticsearch
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch

#install kibana
echo "deb http://packages.elastic.co/kibana/4.5/debian stable main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo apt-get -y install kibana
sed -i 's/# server.host: "0.0.0.0"/ server.host: "localhost"/g' /opt/kibana/config/kibana.yml
#enable the Kibana service
sudo systemctl daemon-reload
sudo systemctl enable kibana
sudo systemctl start kibana

#Install Nginx
sudo apt-get -y install nginx
sudo -v
#echo "kibanaadmin:`openssl passwd -apr1`" | sudo tee -a /etc/nginx/htpasswd.users  # need to pass the password and confirm password
echo "admin:`openssl passwd -apr1 'Password4321'`" | sudo tee -a /etc/nginx/htpasswd.users
cat /dev/null > /etc/nginx/sites-available/default
wget https://raw.githubusercontent.com/sysgain/MSOSS/staging/scripts/default -O /etc/nginx/sites-available/default

sudo nginx -t
sudo systemctl restart nginx
sudo ufw allow 'Nginx Full'

#Install Logstash
echo "deb http://packages.elastic.co/logstash/2.3/debian stable main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo apt-get install logstash

#Generate SSL Certificates
sudo mkdir -p /etc/pki/tls/certs
sudo mkdir /etc/pki/tls/private
sed -i '/\[ v3_ca \]/a subjectAltName = IP: 10.0.2.4' /etc/ssl/openssl.cnf
cd /etc/pki/tls
sudo openssl req -config /etc/ssl/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt

#Configure Logstash
wget https://raw.githubusercontent.com/sysgain/MSOSS/staging/scripts/02-beats-input.conf -O /etc/logstash/conf.d/02-beats-input.conf
sudo ufw allow 5044
wget https://raw.githubusercontent.com/sysgain/MSOSS/staging/scripts/10-syslog-filter.conf -O /etc/logstash/conf.d/10-syslog-filter.conf
wget https://raw.githubusercontent.com/sysgain/MSOSS/staging/scripts/30-elasticsearch-output.conf -O /etc/logstash/conf.d/30-elasticsearch-output.conf
sudo /opt/logstash/bin/logstash --configtest -f /etc/logstash/conf.d/
sudo systemctl restart logstash
sudo systemctl enable logstash

#Load Kibana Dashboards
cd ~
curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.2.2.zip
sudo apt-get -y install unzip
unzip beats-dashboards-*.zip
cd beats-dashboards-*
./load.sh

#Load Filebeat Index Template in Elasticsearch
cd ~
curl -O https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json
curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@filebeat-index-template.json
