#!/bin/sh


# Keep the linedrv_logger running

while [ "1" -eq "1" ]
do

doy=`date "+%j"`

   
/usr/local/bin/linedriver_logger /usr/local/logs/linedrv/linedriver_logger/linedriver_logger.${doy}.log 172.16.102.43 8000 >/dev/null 

	# Let's sleep a while before we try to restart it...
	sleep 60

done

