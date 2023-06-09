#! bin/bash

COMPONENT=MongoDB

source ./common.sh

echo -e "\e[92m############ $COMPONENT Installation started ############\e[0m"

echo -ne "\e[36m setup $COMPONENT repo for yum package manager \e[0m"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
status $?

echo -ne "\e[36m Install $COMPONENT and start service \e[0m"
yum install -y mongodb-org	&>>$LOGFILE
systemctl start mongod
status $?

echo -ne "\e[36m updating $COMPONENT IP address \e[0m"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf
status $?

echo -ne "\e[36m Starting $COMPONENT \e[0m"
systemctl daemon-reload
systemctl enable mongod
#using restart so that there is no error even if the script is run when mongodb has already started
systemctl restart mongod
status $?

echo -ne "\e[36m Downloading the $COMPONENT Schema \e[0m"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
status $?

echo -ne "\e[36m Extracting the $COMPONENT Schema \e[0m"
cd /tmp
unzip -o mongodb.zip &>>$LOGFILE
status $?

echo -ne "\e[36m Injecting the $COMPONENT Schema \e[0m"
cd mongodb-main
mongo < catalogue.js &>>$LOGFILE
mongo < users.js &>>$LOGFILE
status $?

echo -e "\e[92m############ $COMPONENT Installation is completed ############\e[0m"