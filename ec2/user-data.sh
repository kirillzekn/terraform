#!/usr/bin/bash
yum install -y httpd
chown -R -v ec2-user /var/www/html/
echo "Hello World $(hostname -f) " > /var/www/html/index.html
systemctl start httpd  