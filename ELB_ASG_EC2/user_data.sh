#!/bin/bash
sudo yum -y install httpd
sudo chown -R -v ec2-user /var/www/html/
echo "Hello World $(hostname -f) version 3.0" > /var/www/html/index.html
sudo systemctl start httpd