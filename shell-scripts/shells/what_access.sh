#!/bin/ksh
#
# Program Name	: what.sh
# Description	: Show the weekend access flag for a given user.
# Author	: Steven Randlett
# Date		: 6-26-97
# Related files : deny_access.sh allow_access.sh login_net.sh wkend_access
# Modifications :
#

# Weekend access database location and name.
ACCDATA=/usr/lnk/daily/remote/access_weekend.dbs
userfound=0
CR="
"

#
# Main routine
#

if [ "$#" -ne "1" ]
then
	echo "usage: what_access.sh username"
	exit 1
fi
exec<$ACCDATA

userfound=0
while :
do
	
	read line
	if [ "$line" = "" ] 
	then
		break
	fi
	name="`echo $line|awk '{ print $1 }'`"
	if [ "$name" = "$1" ]
	then
		userfound="1"
		access="`echo $line|awk '{ print $2 }'`"
		break
	fi
done

if [ "$userfound" = "1" ]
then
	echo "User $1 access is set to $access."
	exit 0
else
	echo "User $1 was not found in the database."
	exit 1
fi

exit 1
