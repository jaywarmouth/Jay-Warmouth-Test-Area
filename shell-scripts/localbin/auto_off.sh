#!/bin/sh

#	Name: auto_off.sh
#	By  : Steven Randlett
#	Date: 8/13/98
#	Purpose:
#		When this shell script runs as root, it will kill off all processes except ones owned by root and 
#		ones owned by users listed in the file $SKIPFILE.  Lines in $SKIPFILE which begin with a '#'
#		are ignored.
#		This will loop through the entire process table 3 times.  Each time a more aggressive
#		signal is sent to programs which are still running; SIGHUP, SIGTERM, and finally SIGKILL.
#	Modifications:
#			9/14/98 SRR
#			Added code to check for root user
#			cleaned up log so header bar is only seen once (see references to FIRST_TIME variable)
#			10/9/2012 LSJ
#			Changed tail command from "tail +2" to "tail --lines=+2"
#


##
#echo "ATTENTION:"
#echo "THIS SHELL NEEDS TO BE REVIEWED AND TESTED BEFORE USED ON RH8"
#echo "exiting"
	

#exit 1
##



check_for_root()
{
        c_uid=`id -u`
        if [ "$c_uid" -ne "0" ]
        then
                echo "You need to be root to run this program!"
                exit 100
        fi
}




logoff_user()
{
OIFS=$IFS
IFS=$CR
FIRST_TIME="1"

	for data in `ps -ef | tail --lines=+2`
	do
		IFS=$OIFS
		name=`echo $data|awk '{ print $1 }'`
		if [ "$name" = "root" ]
		then
			continue
		fi
		pid=`echo $data|awk '{ print $2 }'`

		skip="0"
		IFS=$CR
		for s_name in `cat $SKIPFILE | grep -v "^#"`
		do
			if [ "$name" = "$s_name" ]
			then
				skip="1"
				break
			fi
		done
		if [ "$skip" -eq "0" ]
		then
			if [ "$pid" -lt "10" ]
			then
				echo "WARNING!  $pid process id would have been killed!"
			else
				USERS_FOUND=`expr $USERS_FOUND + 1`
				if [ "$FIRST_TIME" -eq "1" ]
				then
					ps -fp $pid >>$LOGFILE 
					FIRST_TIME="0"
				else
					ps -fp $pid | tail --lines=+2 >>$LOGFILE
				fi

				kill $KILL_ARG $pid
			fi
		fi

		IFS=$CR  
		
	done	

}









#######
# MAIN
#######

MAILUSER="operator@pdmi.com"
USERS_FOUND="0"
LOGFILE="/tmp/.auto_off.log"
SKIPFILE="/usr/local/etc/auto_off.skip"
CR="
"

check_for_root

echo "--------------------------------------------------------">>$LOGFILE
echo `date`>>$LOGFILE
echo "--------------------------------------------------------">>$LOGFILE
echo "*** SIGHUP ***">>$LOGFILE
KILL_ARG="-HUP"
	logoff_user
	sleep 5	

echo "*** SIGTERM ***">>$LOGFILE
KILL_ARG="-15"
	logoff_user
	sleep 5

echo "*** SIGKILL ***">>$LOGFILE
KILL_ARG="-9"
	logoff_user

# if [ "$USERS_FOUND" -ne 0 ]
# then
# echo "$USERS_FOUND processes killed by auto_off.sh.  Check $LOGFILE for more details."|mailx -s "auto_off"  $MAILUSER
# fi

