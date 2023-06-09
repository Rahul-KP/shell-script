#! bin/bash

status() {
	if [ $1 -eq 0 ] ; then
		echo -e "\e[32m success\n\e[0m"
	else
		echo -e "\e[31m failure\n\e[0m"
	fi
}