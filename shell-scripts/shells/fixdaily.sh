#!/bin/sh


if [ "$1" = "" ]
then
	echo "USAGE: fixdaily.sh filename"
	exit 1
fi

tmpfile="/tmp/fixdaily.$$"

cat $1 | grep -v "^Line" | cut -c 8- > $tmpfile

IFS="
"

for line in `cat $tmpfile`
do
	echo "Line=88"
	echo $line
	echo -e -n "\n"
done


rm -f $tmpfile

exit 0


