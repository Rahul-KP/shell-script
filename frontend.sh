#! bin/bash

COMPONENT=frontend

echo -e "\e[92m############ $COMPONENT Installation started ############\e[0m"

echo -e "\e[36m Installing Nginx\e[0m"
yum install nginx -y
systemctl enable nginx
systemctl start nginx

echo -e "\e[36m Downloading the $COMPONENT component\e[0m"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"

echo -e "\e[36m Performing cleanup\e[0m"
cd /usr/share/nginx/html
rm -rf *

echo -e "\e[36m Extracting \e[0m"
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m Starting Nginx server \e[0m"
systemctl daemon-reload
systemctl enable nginx
systemctl restart nginx

echo -e "\e[92m############ $COMPONENT Installation Complete ############\e[0m"