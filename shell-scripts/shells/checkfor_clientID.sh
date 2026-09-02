#!/bin/sh
#

usage()
{
	echo "USAGE:"
	echo "checkfor_client.sh id filename"
	echo "id	- clientID"
	echo "filename	- filename with list of clientIDs"
}

if [ $# -lt 2 ]
then
	usage
	exit 99
else
	ID=$1
	ID_LISTFILE=$2
fi

if test -s $ID_LISTFILE
then
	FOUND=0
	for line in `cat $ID_LISTFILE | grep -v "^#"`
	do
		FID=`echo $line | awk -F"|" '{ print $1 }'`
		if [ "$FID" = "$ID" ]
		then 
			FOUND=1
			echo "YES"
			exit 0
		fi
	done
	echo "NO"
	exit 0
else
	exit 99
fi

