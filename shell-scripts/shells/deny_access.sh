#!/bin/ksh
#
# Program Name	: deny_access.sh
# Description	: Shell to turn off weekend access to system(s).
# Author	: Steven Randlett
# Date		: 6-26-97
# Related files : allow_access.sh what_access.sh login_net.sh wkend_access
# Modifications :
#

# Weekend access database location and name.
ACCDATA=/usr/lnk/daily/remote/access_weekend.dbs
TMPFILE=$HOME/access_file.$$
userfound=0
CR="
"

#
# Main routine
#

trap 'rm -f $TMPFILE' 0, 1, 2

if [ "$#" -ne "1" ]
then
	echo "usage: deny_access.sh username"
	exit 1
fi
rm -f $TMPFILE
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
		echo "$name		0">>$TMPFILE
		userfound=1
	else
		echo $line >>$TMPFILE
	fi
done

if [ "$userfound" = "1" ]
then
	cp $TMPFILE $ACCDATA
	echo "User $1 has been denied access on weekends."
	exit 0
else
	echo "User $1 was not found in the database."
	exit 1
fi

exit 1
