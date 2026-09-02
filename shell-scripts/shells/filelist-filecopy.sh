#!/bin/sh
#

usage()
{
	echo "USAGE:"
	echo "filelist-filecopy.sh filename from_location to_location"
	echo "  filename - list of files to be copied"
	echo "  from_location - full directory name where copying FROM"
	echo "  to_location - full directory name where copying TO"
	echo " "
}

if [ $# -eq 0 ]
then
	usage
	exit 99
fi

filelist=$1
fr_loc=$2
to_loc=$3
for file in `cat $filelist`
do
	echo $file
	cp $fr_loc/$file $to_loc
done

exit 0
