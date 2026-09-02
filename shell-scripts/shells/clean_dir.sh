#!/bin/sh

usage() 
{
	echo "$0 path days"
	echo "path - path with directory to clean"
	echo "days - remove files older than number of days"
	echo "       This is relative to the newest file in the directory."
}

#
# MAIN
#

if [ "$2" = "" ]
then
	usage
	exit 1
fi

clean_path="$1"
clean_days="`expr $2 + 0`"


if [ "$clean_days" -lt "1" ]
then
	echo "Invalid number of days."
	exit 1
fi


if [ ! -d "$clean_path" ]
then
	echo "$clean_path does not exist"
	exit 1
fi

for filename in `find $clean_path -type f -print`
do

	if [ ! -f "$filename" ]
	then
		continue
	fi
	line=`ls -l --time-style="+%s" $filename`
	seconds=`echo $line | awk '{ print $6 }'`
	file=`echo $line | awk '{ print $7 }'`

	days="`expr $seconds / 86400`"

	for f2 in `find $clean_path -type f -print`
	do
		if [ ! -f "$f2" ]
		then
			continue
		fi
		line2=`ls -l --time-style="+%s" $f2`
		seconds2=`echo $line2 | awk '{ print $6 }'`
		file2=`echo $line2 | awk '{ print $7 }'`

		days2="`expr $seconds2 / 86400`"

		gap="`expr $days - $days2`"
		if [ "$gap" -ge "$clean_days" ]
		then
			rm -f $file2
		fi

	done

	
done
