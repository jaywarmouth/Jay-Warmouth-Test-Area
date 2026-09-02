#!/bin/sh



# must be root.


#       Name: unexpire.sh (formally renew_user.sh)
#       By  : Steven Randlett
#       Date: 9/8/98
#       Purpose:
#	Mass account-reactivation program.  
#	
#	Modifications:
#	12/02/98 SRR - Added code so login ids can be entered on the command line
#		for updating indiviual users.
#
#


usage()
{
cat <<-USAGE
USAGE:  unexpire.sh [user user ...]

USAGE
}


check_for_root()
{
        c_uid=`id -u`
        if [ "$c_uid" -ne "0" ]
        then
                echo "You need to be root to run this program!"
                exit 100
        fi
}

update_user()
{
# Creates updated $UPDATE_FILE which login shell uses to 
# determine last login time.

FOUND="0"
	eval `/usr/local/bin/findhome $rname`
	homedir=$pw_dir
	lname=$pw_name
	name=$pw_gecos

	if [ "$lname" = "$rname" ]
	then
		echo "Reactivating $lname"

		today=`date "+%D %T %Z"`
		echo "$lname|Reactivated|${today}|$name" >>${homedir}/${UPDATE_FILE}
                echo "${today}\t$lname\t$LOGNAME" >> ${LOGFILE}
		chown $lname ${homedir}/${UPDATE_FILE}
		FOUND="1"
		break 
	fi
}

non_interactive()
{
echo "Enter reactivation (.renew) file:"
read LPREFIX

if [ ! -f ${LPREFIX}.renew ]
then
	echo "${LPREFIX}.renew does not exist!"
	echo "$0 aborted!"
	exit 1
fi


	OIFS=$IFS
	IFS=$CR
	for rname in `cat ${LPREFIX}.renew`
	do
		IFS=$OIFS		
		update_user
		if [ "$FOUND" -ne "1" ]
		then
			echo "User $rname not found to update!"
		fi
		IFS=$CR
	done
 

}

#############
#
# MAIN
#
#############


UPDATE_FILE=".lastlogin"
LOGFILE="/usr/local/logs/unexpire.log"
CR="
"


check_for_root

if [ "$#" -gt "0" ]
then
	while [ "$1" != "" ]
	do
		rname="$1"
		update_user
		if [ "$FOUND" -ne "1" ]
		then
			echo "User $rname not found to update!"
		fi



		shift

	done
else
		non_interactive
fi




	echo " "

