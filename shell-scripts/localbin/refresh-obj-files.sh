#!/bin/sh
#

usage()
{
	echo "USAGE:"
	echo "refresh-obj-files.sh from_location to_location"
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

exit 0
