#!/bin/sh


# Keep the formulary73 running

while [ "1" -eq "1" ]
do

   
	echo "`date` formulary73 restart" >>/usr/local/logs/formulary/formulary73_restart.log
	su - pdmisvc -c "/usr/lnk/shell/formulary73.sh -l 125 2>&1 | /usr/local/bin/logpipe -d -p /usr/local/logs/formulary/formulary73"

	# Let's sleep a while before we try to restart it...
	sleep 15
done

