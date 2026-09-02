#!/bin/sh


RMCOBOL_RECOVERY="/opt/rmcobol/recover1"
RMCOBOL_RECOVERY="/usr/rmcobol/recover1"


TMPFILE="/tmp/cobol_file_integiry_check.dropped.$$"
return_valie="0"

usage()
{
	echo "$0 [-s|-R] filename"
	echo "filename - contains a list of RMCOBOL files to check for validity"
	echo "-s - short circuit, exit when first file is identified as corrupt"
	echo "-R - perform recovery on files identified as corrupt"
	exit 1
}

OIFS="$IFS"
CR="
"


short_circuit="0"
do_recovery="0"


while [ "$1" != "" ]
do
	param="$1"
	case $param in
	"-s")
		short_circuit="1"
		;;
	"-R")
		do_recovery="1"
		;;
	*)
		if [ "$filename" != "" ]
		then
			echo "Bad parameter $param"
			usage
			exit 1
		fi
		filename="$1"
		;;
	esac

shift

done

if [ "$filename" == "" ]
then
	usage
	exit 1
fi


if [ ! -f "$filename" ]
then
	echo "No such file $filename"
	exit 2
fi


if [ "$do_recovery" -eq "1" -a "$short_circuit" -eq "1" ]
then
	echo "Cannot use -s and -R at the same time"
	usage
	exit 2
fi


echo "START:    `date --iso-8601=seconds`"
IFS="$CR"
for file in `cat $filename | grep -v "^#"`
do

	IFS="$OIFS"

	echo "CHECK:    $file"

	$RMCOBOL_RECOVERY $file $TMPFILE /tmp/junk.$$ -Q -I
	retval="$?"

	rm -f $TMPFILE
	if [ "$retval" -ne "0" ]
	then
		echo "FAIL:     $file failed integrity check"
		return_value="1"
		if [ "$short_circuit" -eq "1" ]
		then
			break
		fi
		if [ "$do_recovery" -eq "1" ]
		then
			echo "RECOVER:   $file"
			$RMCOBOL_RECOVERY $file $TMPFILE /tmp/junk.$$ -Q -I
		fi
	fi

	IFS="$CR"

done

echo "COMPLETE: `date --iso-8601=seconds`"

exit $return_value
