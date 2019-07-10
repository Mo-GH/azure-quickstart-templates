#!/bin/bash

# The MIT License (MIT)
#
# Copyright (c) 2019 Mohamad Ghanem
Script Parameters
ES_VERSION="7.1.1"
Name="localhost"
PORT=9200
ElS_ADDRESS= "http://localhost:9200"

install_java()
{
if type -p java; then
    echo found java executable in PATH
    _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    echo found java executable in JAVA_HOME     
    _java="$JAVA_HOME/bin/java"
else
    echo "no java"
    
    log "Installing Java 11"
    
    apt update && sudo apt install --assume-yes openjdk-11-jre-headless
    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
fi
}

install_es()
{
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
    apt update && sudo apt install --assume-yes elasticsearch 
   
}

configure_es()
{
	log "Update configuration"
	mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.bak
	echo "network.host: $Name" >> /etc/elasticsearch/elasticsearch.yml
	echo "http.port: $PORT" >> /etc/elasticsearch/elasticsearch.yml
	echo "cluster.initial_master_nodes: $Name" >> /etc/elasticsearch/elasticsearch.yml

}

install_logstash()
{
 apt update && sudo apt install --assume-yes logstash
}

install_kibana()
{
 apt update && sudo apt install --assume-yes kibana
}
configure_Kibana()
{
	log "Update configuration Kibana"
	mv /etc/kibana/kibana.yml /etc/kibana/kibana.bak
  echo "server.port: 5601" >> /etc/elasticsearch/elasticsearch.yml
	echo "elasticsearch.hosts: $ElS_ADDRESS" >> /etc/elasticsearch/elasticsearch.yml
}

start_service_els()
{
  systemctl start elasticsearch.service
  service elasticsearch start
}
start_service_Kibana()
{
 systemctl start kibana.service
  service kibana start
} 

echo "starting elasticsearch setup"

install_java
install_es
start_service_els


echo "completed elasticsearch setup"

exit 0
