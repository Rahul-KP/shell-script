#! bin/bash

COMPONENT=user

source ./common.sh

echo -e "\e[92m############ $COMPONENT Component Installation Started ############\e[0m"

echo -ne "\e[36m Downloading and Installing NodeJS \e[0m"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>$LOGFILE
yum install nodejs -y &>>$LOGFILE
status $?

#Add user only if user does not exist
id $USER &>>LOGFILE
if [ $? -ne 0 ] ; then
    echo -ne "\e[36m creating $USER user \e[0m"
    useradd $USER &>>$LOGFILE
    status $?
fi

echo -ne "\e[36m Downloading the $COMPONENT component \e[0m"
curl -s -L -o /tmp/$COMPONENT.zip  "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
status $?

echo -ne "\e[36m Extracting the $COMPONENT component \e[0m"
cd /home/$USER
rm -rf $COMPONENT &>>$LOGFILE
unzip -o /tmp/$COMPONENT.zip &>>$LOGFILE
status $?

echo -ne "\e[36m Generating npm $COMPONENT artifacts \e[0m"
mv $COMPONENT-main $COMPONENT
cd /home/$USER/$COMPONENT
npm install &>>$LOGFILE
status $?

echo -ne "\e[36m Updating SystemD file with correct IP address \e[0m"
sed -i -e "s/MONGO_ENDPOINT/mongodb.$USER.internal/" -e "s/REDIS_ENDPOINT/redis.$USER.internal/" ./systemd.service
status $?

echo -ne "\e[36m Setup and start the $COMPONENT service \e[0m"
mv /home/$USER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
systemctl daemon-reload &>>$LOGFILE
systemctl restart $COMPONENT &>>$LOGFILE
systemctl enable $COMPONENT &>>$LOGFILE
status $?

echo -ne "\e[36m############ Installation of $COMPONENT component is complete ############\e[0m"