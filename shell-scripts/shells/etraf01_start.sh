#!/bin/sh

# Version 1.1 - Changed DevTest20 reference to UATTrans20

check_for_root()
{
        c_uid=`id -u`
        if [ "$c_uid" -ne "0" ]
        then
                echo "You need to be root to run this program!"
                exit 100
        fi
}

check_for_root
datetime=`/bin/date "+%Y%m%d_%H%M%S"`
LHOST=`/bin/hostname -s`

/usr/lnk/shell/range_clrmsg.sh 800 805

# Program to start ePrescribing COBOL program
if [ $LHOST = "UATTrans20" ]
then
	/usr/lnk/shell/etraf01.sh -t -l 800 2>&1 | /usr/local/bin/logpipe -d -p /tmp/.etraf01
else	
	/usr/lnk/shell/etraf01.sh -l 800 2>&1 | /usr/local/bin/logpipe -d -p /tmp/.etraf01 
fi


