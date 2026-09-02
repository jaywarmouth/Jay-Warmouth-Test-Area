#!/bin/sh
#

usage()
{
	echo "USAGE:"
	echo "refresh-objshell-files.sh from_location to_location"
	echo "  to_location - server name where copying TO"
}

if [ $# -eq 0 ]
then
	usage
	exit 99
fi

to_loc=$1

date
echo "Copying *.cob files to $to_loc"
scp -q /usr/lnk/obj/*.cob $to_loc:/usr/lnk/obj
date
echo "Copying *.sh files to $to_loc"
scp -q /usr/lnk/shell/*.sh $to_loc:/usr/lnk/shell
date
echo "Copying /usr/lnk/log files to $to_loc"
scp -q /usr/lnk/log/* $to_loc:/usr/lnk/log
date

exit 0
