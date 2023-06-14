#! bin/bash

COMPONENT=dispatch

source ./common.sh

echo -e "\e[92m############ $COMPONENT Installation started ############\e[0m"

echo -ne "\e[36m Installing Goloang \e[0m"
yum install golang -y &>>$LOGFILE
status $?

CREATE_USER

DOWNLOAD_AND_EXTRACT
mv dispatch-main dispatch 
go mod init dispatch
go get 
go build

CONFIGURE_SERVICE