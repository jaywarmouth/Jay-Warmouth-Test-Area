#!/bin/sh

CR="
"
OIFS="$IFS"

TMPFILE="/tmp/logoff.sh.tmp.$$"

luser="$1"

if [ "$luser" = "" ]
then
	echo "USAGE: logoff.sh loginid"
	exit 1
fi

IFS="$CR"

#	ps --no-headers -fu ${luser} | sort -r >$TMPFILE


       for LINE in `ps --no-headers -fu ${luser} | sort -r`
       do
	IFS="$OIFS"
#	echo $LINE
         PID=`echo ${LINE} | awk '{ print $2 }'`
         PP=`echo ${LINE} | awk '{ print $3 }'`


         if [ "${PID}" -gt "1" ]
         then
		if [ "${PID}" -ne "$$" -a "${PP}" -ne "$$" -a "$PID" -ne "$PPID" -a "$PP" -ne "$PPID" ]
		then
           		kill -9 ${PID} 
		fi
         fi
         IFS=${CR}
       done

#rm -f $TMPFILE
