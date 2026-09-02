#!/bin/sh


while [ "1" -eq "1" ]
do
switchdate=`/bin/date "+%Y%m%d"`
/usr/local/bin/claimstream /usr/lnk/daily/switch40/switch40-${switchdate}

sleep 1

done
