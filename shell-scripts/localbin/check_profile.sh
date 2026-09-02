#!/bin/sh

#
# Created: 5/23/06
# By: Steven Randlett
# Purpose: Check to make sure we don't have invalid .bash_profiles floating
# around on end-user accounts, which would be a major security hole.

LOGFILE="/tmp/check_profile.$$"
TMPFILE="/tmp/check_profile_tmp.$$"
MAILUSERS="networking@pdmi.com"
HOST=`hostname`

for username in `cat /etc/passwd | awk -F: '{ print $1 }'`
do

        eval `/usr/local/bin/findhome $username`
        if [ "$pw_uid" -gt "500" -a "$pw_shell" != "/sbin/nologin" ]
        then

		profile="${pw_dir}/.bash_profile" 
	#	echo $profile
                if [ -f "$profile" ]
                then
			cat $profile | grep -v "^#" | egrep "exec /usr/bin/passwd|exec /usr/local/bin/login_netw.sh|exec /usr/local/bin/login_netw-2s.sh|exec sleep 60|exec /usr/local/bin/login_passwd.sh" > $TMPFILE

			if [ ! -s "$TMPFILE" ]
			then
				echo "$pw_name - profile is bad" | tee -a $LOGFILE
			#	echo "$pw_name - profile is bad" 
			fi
                else
                        echo "$pw_name - NO PROFILE!" | tee -a $LOGFILE
                       # echo "$pw_name - NO PROFILE!" 
                fi
        fi


done

if [ -s "$LOGFILE" ]
then

	echo "The following accounts do not have a properly formatted .bash_profile.  This is a security issue.  Please review the following accounts on $HOST ASAP." >$TMPFILE
	echo " " >>$TMPFILE
	cat $LOGFILE >>$TMPFILE
	cat $TMPFILE | mail -s "bash_profile errors" $MAILUSERS
fi

rm -f $LOGFILE $TMPFILE

