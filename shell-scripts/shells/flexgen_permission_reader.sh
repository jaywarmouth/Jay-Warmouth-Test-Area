#!/bin/sh


output_filename="$1"
RANDOM_FILENAME="/tmp/.fpr.$$"

OIFS="$IFS"
CR="
"


if [ "$output_filename" = "" ]
then
	output_filename="${RANDOM_FILENAME}"
else
	RANDOM_FILENAME="${output_filename}"
fi


counter="1"
while [ -f "${output_filename}" ]
do
	output_filename="${RANDOM_FILENAME}.${counter}"

	counter=`expr $counter + 1`
done

touch "${output_filename}"

echo "READY FOR DATA:"

IFS="$CR"
while [ -z "$eof" ]
do
	read line || eof=true
	if [ -z "$eof" ]
	then
		echo $line >>$output_filename
	fi
done
IFS="$OIFS"

echo "FILENAME: ${output_filename}"

echo "Press ENTER to continue"
read JUNK

exit 0
