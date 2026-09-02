#!/bin/sh

VERSION="0.9"

# Program: submit_rte.sh
# Date: 2016-04-07
# Purpose: submit raw RTE transactions to elgrt02

usage()
{
	echo "submit_rte.sh version $VERSION"
	echo "USAGE: submit_rte.sh [-q] data_q elgrt_q clientid data_file response_file "
	echo "-q - quiet, don't show stats"
	echo "data_q - temporary queue used to store data"
	echo "elgrt_q - queue elgrt02 is running on"
	echo "clientid - client id to send to elgrt02"
	echo "data_file - data file with RTE formatted records"
	echo "response_file - file to write responses to"
}

# MAIN

quiet="0"

	if [ "$1" == "-q" ]
	then
		quiet="1"
		shift
	fi

	if [ "$#" -ne "5" ]
	then
		usage
		exit 1
	fi

	data_q="$1"
	elgrt_q="$2"
	clientid="$3"
	data_file="$4"
	response_file="$5"

	if [ ! -f "$data_file" ]
	then
		echo "File ${data_file} doesn't exist!"
		exit 2
	fi

CR="
"

OIFS="$IFS"
IFS="$CR"

rm -f $response_file
clrmsg $data_q >/dev/null

TMPFILE="/tmp/${clientid}_D_$$"

total_records=`wc -l $data_file | awk '{ print $1 }'`

	record_count="0"

if [ "$quiet" == "0" ]
then
	message="${record_count}/${total_records}    "

	echo -n $message

fi

	for line in `cat $data_file`
	do
		record_count=`expr $record_count + 1`

		echo "${clientid}" > $TMPFILE
		echo -ne "submit_rte-${record_count}\003" >> $TMPFILE
		echo -n "${line}" >> $TMPFILE

		echo -e "$TMPFILE\003" | sndmsg $data_q stdin 1 >/dev/null
		echo  "$data_q" | sndmsg $elgrt_q stdin 1 25 >/dev/null
		
		response=`rcvmsg $data_q 2`
		echo "submit_rte-${record_count}: ${response%%*}" >> $response_file


if [ "$quiet" == "0" ]
then

		for (( c=1; c<=${#message}; c++))
		do
			echo -ne "\b"
		done

		message="${record_count}/${total_records} "
		echo -n $message
		
fi


	done

if [ "$quiet" == "0" ]
then

echo " "
echo "Complete."

fi

#rm -f $TMPFILE	
