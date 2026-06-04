#!/bin/bash

apt-get update -y

apt-get install nginx -y

systemctl enable nginx
systemctl restart nginx

echo "<h1>VMSS Instance Running</h1>" > /var/www/html/index.html