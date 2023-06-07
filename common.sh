#! bin/bash

status() {
	if [ $1 -eq 0 ] ; then
		echo -n "\e[32msuccess\e[0m"
	else
		echo -n "\e[31mfailure\e[0m"
	fi
}