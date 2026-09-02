#!/bin/sh
#

# Variables:
SHELL_DIR=/usr/lnk/shell
DATE=`date +%Y%m%d`
COMPU13LOG=/tmp/compu13log_${USER}_${DATE}.txt
LOG=/tmp/filefixerror.txt


ps -e | grep recover > /dev/null 2>&1
if [ $? -eq 1 ]
then
	${SHELL_DIR}/checkindexfiles.sh > /tmp/null 2>&1
	if test -s $COMPU13LOG
	then
		${SHELL_DIR}/updaudit-spechusk.sh -r prod10 -now > /tmp/null 2>&1
	fi
else
	echo "A file recover is currently running on Husk." > $LOG
	echo "When completed, run the following on Husk (operator user):" >> $LOG
	echo "/usr/lnk/shell/updaudit-spechusk.sh -r prod10 -now" >> $LOG
	cat $LOG | /bin/mail -s "Husk updaudit and recovery message" operations@pdmi.com
fi

exit 0
