#! bin/bash

status() {
	if [ $1 -eq 0 ] ; then
		echo -ne "\e[32msuccess\e[0m"
	else
		echo -ne "\e[31mfailure\e[0m"
	fi
}