#! bin/bash

COMPONENT=frontend

source ./common.sh

echo -e "\e[92m############ $COMPONENT Installation started ############\e[0m"

echo -ne "\e[36m Installing Nginx\e[0m"
yum install nginx -y	&>>$LOGFILE
systemctl enable nginx	&>>$LOGFILE
systemctl start nginx	&>>$LOGFILE
status $?

echo -ne "\e[36m Downloading the $COMPONENT component\e[0m"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
status $?

echo -ne "\e[36m Performing cleanup\e[0m"
cd /usr/share/nginx/html
rm -rf *
status $?

echo -ne "\e[36m Extracting \e[0m"
unzip /tmp/frontend.zip		&>>$LOGFILE
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
status $?

echo -ne "\e[36m Configuring reverse proxy settings \e[0m"
for component in catalogue user cart shipping payment dispatch; do
    sed -i -e "/$component/s/localhost/$component.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
done
status $?

echo -ne "\e[36m Starting Nginx server \e[0m"
systemctl daemon-reload
systemctl enable nginx	
systemctl restart nginx	
status $?

echo -e "\e[92m############ $COMPONENT Installation Complete ############\e[0m"