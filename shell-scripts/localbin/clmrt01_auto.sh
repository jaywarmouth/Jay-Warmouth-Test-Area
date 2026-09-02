#!/bin/sh


# Keep the clmrt running

while [ "1" -eq "1" ]
do

	echo "`date` clmrt01 restart" >>/usr/local/logs/rtc/clmrt01_restart.log
	/usr/local/bin/clmrt01_start.sh

	# Let's sleep a while before we try to restart it...
	sleep 5

done

