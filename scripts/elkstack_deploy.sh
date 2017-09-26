#!/bin/sh
DATE=`date +%Y%m%d%T`
LOG=/tmp/elkstack_deploy.log.$DATE
sudo add-apt-repository -y ppa:webupd8team/java >> $LOG
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - >> $LOG
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list >> $LOG
echo "deb http://packages.elastic.co/kibana/4.5/debian stable main" | sudo tee -a /etc/apt/sources.list >> $LOG
echo "deb http://packages.elastic.co/logstash/2.3/debian stable main" | sudo tee -a /etc/apt/sources.list >> $LOG
curl -L https://download.elastic.co/beats/dashboards/beats-dashboards-1.2.2.zip -o /root/beats-dashboards-1.2.2.zip >> $LOG
curl -L https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json -o /root/filebeat-index-template.json >> $LOG
sudo apt-get update >> $LOG
sudo apt-get -y install oracle-java8-installer elasticsearch kibana nginx >> $LOG
