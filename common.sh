#! bin/bash

LOGFILE="/tmp/${COMPONENT}.log"

status() {
	if [ $1 -eq 0 ] ; then
		echo -e "\e[32m success\e[0m"
	else
		echo -e "\e[31m failure\e[0m"
	fi
}