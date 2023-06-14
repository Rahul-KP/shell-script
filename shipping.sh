#! bin/bash

COMPONENT=shipping

source ./common.sh

JAVA

# echo -e "\e[92m############ $COMPONENT Component Installation Started ############\e[0m"

# echo -ne "\e[36m Installing Maven \e[0m"
# yum install maven -y
# status $?

# echo -ne "\e[36m Creating user $USER \e[0m"
# cd /home/$USER
# status $?

# echo -ne "\e[36m Downloading $COMPONENT component \e[0m"
# curl -s -L -o /tmp/shipping.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
# status $?

# echo -ne "\e[36m Extracting $COMPONENT component \e[0m"
# unzip /tmp/shipping.zip
# status $?
# mv $COMPONENT-main $COMPONENT
# cd $COMPONENT
# mvn clean package 
# mv target/shipping-1.0.jar shipping.jar

# echo -ne "\e[36m Updating systemD file \e[0m"
