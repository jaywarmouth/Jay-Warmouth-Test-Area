#!/bin/sh
# Program Name	: HWFcardh175-daily.sh

# Variables:
DATE=`date +%Y%m%d`
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="healthwell@pdmi.com"



/usr/lnk/shell/cardh175.sh -p /usr/lnk/log/cardh175-parm-0175.txt -o /tmp/HWELL00CSV-${DATE}.txt
RETVAL=$?
if [ $RETVAL = 0 ]
then
	${MAIL_PROG} -s "Daily Heathwell Report" -a /tmp/HWELL00CSV-${DATE}.txt ${MAIL_TO} 
	rm -f /tmp/HWELL00CSV-${DATE}.txt
else
	exit $RETVAL
fi
exit 0
