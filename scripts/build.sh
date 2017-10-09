#!/bin/sh
sudo apt-get update
sudo apt-get install openjdk-8-jdk -y
addgroup hab
sudo useradd -g hab hab
usermod -aG sudo hab
sleep 30
curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash
echo "---Configure Repos for Azure Cli 2.0---" 
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893 
sudo apt-get update
sudo apt-get -y install apt-transport-https azure-cli
