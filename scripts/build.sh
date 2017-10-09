#!/bin/sh
sudo apt-get update
sudo apt-get install openjdk-8-jdk -y
addgroup hab
sudo useradd -g hab hab
usermod -aG sudo hab
