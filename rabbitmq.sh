#!/bin/bash 

COMPONENT="rabbitmq"

source ./common.sh

echo -e "\e[92m############ $COMPONENT Component Installation Started ############\e[0m"

echo -n "Configuring the $COMPONENT repo: "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash   &>> $LOGFILE
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash     &>> $LOGFILE
status $? 

echo -n "Installing $COMPONENT: "
yum install rabbitmq-server -y      &>> $LOGFILE 
status $? 

echo -n "Starting $COMPONENT :"
systemctl enable rabbitmq-server    &>> $LOGFILE
systemctl restart rabbitmq-server   &>> $LOGFILE
status $?

# This needs to run only if the user account doesn't exist 
rabbitmqctl list_users | grep roboshop  &>> $LOGFILE 
if [ $? -ne 0 ] ; then 
    echo -n "Creating the $COMPONENT $APPUSER :"
    rabbitmqctl add_user roboshop roboshop123    &>> $LOGFILE
    status $?
fi 

echo -n "Configuring the $COMPONENT $APPUSER privileges:"
rabbitmqctl set_user_tags roboshop administrator     &>> $LOGFILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"     &>> $LOGFILE
status $? 

echo -e "\e[92m############ $COMPONENT Component complete ############\e[0m"