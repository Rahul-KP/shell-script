#! bin/bash

COMPONENT=mysql

source ./common.sh

echo -e "\e[92m############ $COMPONENT Component Installation Started ############\e[0m"

echo -ne "\e[36m setup $COMPONENT repo for yum package manager \e[0m"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
status $?

echo -ne "\e[36m Installing $COMPONENT \e[0m"
yum install mysql-community-server -y &>>$LOGFILE
status $?

echo -ne "\e[36m Starting $COMPONENT server \e[0m"
systemctl enable $COMPONENT
systemctl restart $COMPONENT
status $?

# echo -ne "\e[36m updating password \e[0m"
# I want this to be executed only if the default password reset was not done. 
echo "show databases;" | mysql -uroot -pRoboShop@1 &>> $LOGFILE
if [ $? -ne 0 ] ; then 
    echo -ne "\e[36m fetching default root password \e[0m"
    DEFAULT_ROOT_PASSWORD=$(grep "temporary password" /var/log/mysqld.log | awk '{print $NF}')
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p${DEFAULT_ROOT_PASSWORD}   &>> $LOGFILE
    status $?
fi 

echo "show plugins;" | mysql -uroot -pRoboShop@1 | grep validate_password &>> $LOGFILE
if [ $? -eq 0 ] ; then 
    echo -n "Uninstalling the validate_password plugin :"
    echo "UNINSTALL PLUGIN validate_password;" | mysql -uroot -pRoboShop@1   &>> $LOGFILE
    status $?
fi

echo -ne "\e[36m Downloading $COMPONENT schema \e[0m"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
status $?

echo -ne "\e[36m Extracting $COMPONENT schema \e[0m"
cd /tmp
unzip mysql.zip &>>$LOGFILE
status $?

echo -ne "\e[36m Injecting $COMPONENT schema \e[0m"
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql &>>$LOGFILE
status $?

echo -e "\e[92m############ $COMPONENT Component Installation Complete ############\e[0m"