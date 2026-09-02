#!/bin/sh


# Keep the tcpsendwebsrv running

while [ "1" -eq "1" ]
do

   
	/usr/lnk/shell/tcpsendwebsrv_db21.sh start

	# Let's sleep a while before we try to restart it...
	sleep 30

done

