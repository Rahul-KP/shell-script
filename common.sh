#! bin/bash

LOGFILE="/tmp/${COMPONENT}.log"
USER=roboshop

status() {
	if [ $1 -eq 0 ] ; then
		echo -e "\e[32m success\e[0m"
	else
		echo -e "\e[31m failure\e[0m"
	fi
}

CREATE_USER() {
	id $USER &>>LOGFILE
	if [ $? -ne 0 ] ; then
		echo -ne "\e[36m creating $USER user \e[0m"
		useradd $USER &>>$LOGFILE
		status $?
	fi
}

DOWNLOAD_AND_EXTRACT() {
	echo -ne "\e[36m Downloading the $COMPONENT component \e[0m"
	curl -s -L -o /tmp/$COMPONENT.zip  "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
	status $?

	echo -ne "\e[36m Extracting the $COMPONENT component \e[0m"
	cd /home/$USER
	rm -rf $COMPONENT &>>$LOGFILE
	unzip -o /tmp/$COMPONENT.zip &>>$LOGFILE
	status $?
}

NPM_INSTALL() {
	echo -ne "\e[36m Generating npm $COMPONENT artifacts \e[0m"
	mv $COMPONENT-main $COMPONENT
	cd /home/$USER/$COMPONENT
	npm install &>>$LOGFILE
	status $?
}

CONFIGURE_SERVICE() {
	echo -ne "\e[36m Updating SystemD file with correct IP address \e[0m"
	sed -i -e "s/MONGO_ENDPOINT/mongodb.$USER.internal/" -e "s/REDIS_ENDPOINT/redis.$USER.internal/" -e "s/CATALOGUE_ENDPOINT/catalogue.$USER.internal/" -e "s/CARTENDPOINT/cart.$USER.internal/" -e"s/DBHOST/mysql.$USER.internal/" ./systemd.service
	status $?

	echo -ne "\e[36m Setup and start the $COMPONENT service \e[0m"
	mv /home/$USER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
	systemctl daemon-reload &>>$LOGFILE
	systemctl restart $COMPONENT &>>$LOGFILE
	systemctl enable $COMPONENT &>>$LOGFILE
	status $?

	echo -ne "\e[36m############ Installation of $COMPONENT component is complete ############\e[0m"
}

NODEJS() {
	echo -e "\e[92m############ $COMPONENT Component Installation Started ############\e[0m"

	echo -ne "\e[36m Downloading and Installing NodeJS \e[0m"
	curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>$LOGFILE
	yum install nodejs -y &>>$LOGFILE
	status $?

	CREATE_USER

	DOWNLOAD_AND_EXTRACT

	NPM_INSTALL

	CONFIGURE_SERVICE
}

MVN_PACKAGE() {
	mv $COMPONENT-main $COMPONENT
	cd $COMPONENT
	mvn clean package &>>$LOGFILE
	mv target/shipping-1.0.jar shipping.jar
}
JAVA() {
	echo -e "\e[92m############ $COMPONENT Component Installation Started ############\e[0m"

	echo -ne "\e[36m Installing Maven \e[0m"
	yum install maven -y &>>$LOGFILE
	status $?

	CREATE_USER

	DOWNLOAD_AND_EXTRACT

	MVN_PACKAGE

	CONFIGURE_SERVICE

}

PYTHON() {
    echo -n "Installing Python and its dependencies :"
    yum install python36 gcc python3-devel -y   &>> $LOGFILE 
    status $? 

    CREATE_USER                 # calling Create_user function to create the roboshop user account

    DOWNLOAD_AND_EXTRACT         # calling DOWNLOAD_AND_EXTRACT  function download the content

    echo -n "Installing $COMPONENT"
	mv $COMPONENT-main $COMPONENT
    cd /home/${USER}/${COMPONENT}/
    pip3 install -r requirements.txt    &>> $LOGFILE 
    status $?

    USERID=$(id -u roboshop)
    GROUPID=$(id -g roboshop) 

    echo -n "Updating the uid and gid in the $COMPONENT.ini file"
    sed -i -e "/^uid/ c uid=${USERID}" -e "/^gid/ c gid=${GROUPID}"  /home/${USER}/${COMPONENT}/${COMPONENT}.ini
    
    CONFIGURE_SERVICE

}