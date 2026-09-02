#!/bin/sh

# when idle time is >= LOGOFFMINS the user is logged off.
# LOGOFFMINS lowerbound=1  upperbound=59
# Users with UID <= 500 or are listed in the EXCLUDE_FILE are never logged off.

LOGOFFMINS="50"

EXCLUDE_FILE="/usr/local/pub/idlelogoff.dat"

CR="
"
OIFS="$IFS"


checkuser() {

un="$1"

RETVAL="0"
OCIFS="$IFS"

IFS="$CR"
	for euser in `cat $EXCLUDE_FILE | grep -v "^#"`
	do

		if [ "$un" = "$euser" ]
		then
			RETVAL="1"
		fi
	done

IFS="$OCIFS"

echo "$RETVAL"
}

IFS="$CR"
for line in `who -u | grep -v " \. "`
do
	IFS="$OIFS"
	itime=`echo $line | awk '{ print $5 }'`
	pid=`echo $line | awk '{ print $6 }'`
	username=`echo $line | awk '{ print $1 }'`
	tty=`echo $line | awk '{ print $2 }'`

	hrs=`echo $itime | awk -F: '{ print $1 }'`
	mins=`echo $itime | awk -F: '{ print $2 }'`

	HoursToMins=`expr $hrs \* 60`
	mins=`expr $mins + $HoursToMins`

	if [ "$mins" -ge "$LOGOFFMINS" ] 
	then
		eval `/usr/local/bin/findhome $username`


		EXCLUDE=`checkuser $username`

		if [ "$EXCLUDE" -eq "0" -a "$pw_uid" -gt "500" ]
		then

			mydate=`date "+%D %T"`
			uinfo="$mydate $username Idle: $itime"

			if [ -w "/dev/${tty}" ]
			then
				echo " " >> /dev/${tty}
				echo "DISCONNECTED  " >> /dev/${tty}
			fi
			/usr/local/bin/logoff.sh $username

			rm -f ${pw_dir}/.linfo
	
			echo $uinfo >> /tmp/.idlelogoff.log
		fi
	fi

	IFS="$CR"

done
