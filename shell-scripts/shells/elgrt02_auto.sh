#!/bin/sh


# Keep the elgrt running

while [ "1" -eq "1" ]
do

	echo "`date` elgrt02 restart" >>/tmp/.elgrt02_restart.log
        su - pdmisvc -c "/usr/lnk/shell/elgrt02.sh -l 80 2>&1 | /usr/local/bin/logpipe -d -p /usr/local/logs/rte/elgrt02"

	# Let's sleep a while before we try to restart it...
	sleep 10

done

