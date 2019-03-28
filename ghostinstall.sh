#!/bin/bash
wget https://ghost.org/zip/ghost-latest.zip
sudo yum update -y
sudo yum install unzip -y
sudo mkdir /var/www
sudo unzip -d /var/www/ghost ghost-latest.zip
cd /var/www/ghost/
sudo npm install --production

sudo cp config.example.js config.js
