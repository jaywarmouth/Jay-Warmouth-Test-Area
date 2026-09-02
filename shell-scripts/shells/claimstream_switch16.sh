#!/bin/sh


while [ "1" -eq "1" ]
do
switchdate=`/bin/date "+%Y%m%d"`
/usr/local/bin/claimstream /usr/lnk/daily/switch16/switch16-${switchdate}

sleep 1

done
