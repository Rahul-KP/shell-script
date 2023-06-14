#! bin/bash

COMPONENT=redis

source ./common.sh

echo -e "\e[92m############ $COMPONENT Installation started ############\e[0m"

echo -ne "\e[36m Adding redis repo to yum package manager \e[0m"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
status $?

echo -ne "\e[36m Installing $COMPONENT \e[0m"
yum install redis-6.2.11 -y &>>$LOGFILE
status $?

echo -ne "\e[36m Updating BindIP addresses \e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPONENT.conf /etc/$COMPONENT/$COMPONENT.conf
status $?

echo -ne "\e[36m Starting $COMPONENT \e[0m"
systemctl enable redis
systemctl restart redis
status $?

echo -e "\e[92m############ $COMPONENT Installation Complete ############\e[0m"