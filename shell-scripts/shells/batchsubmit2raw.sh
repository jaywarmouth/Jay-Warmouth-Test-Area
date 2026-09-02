#!/bin/bash


# Program: batchsubmit2raw.sh
# Date: 2020-12-14
# Purpose: Take NCPDP batch submit formatted transactions and
#	format them to raw NCPDP, one per line

usage()
{
	echo "batchsubmit2raw version 1.0"
	echo USAGE: $0 batchsubmit_file
}




# MAIN
FILENAME="UNSET"



	if [ "$#" -ne "1" ]
	then
		usage
		exit 1
	fi

	infile="$1"

	if [ ! -f $infile ]
	then
		echo "File $infile doesn't exist!"
		exit 2
	fi

CR="
"

OIFS="$IFS"
IFS="$CR"

tmpfile="/tmp/.batchsubmit2raw.tmp.$$"
rm -f $tmpfile

record_count="0"
		#echo  $claimdata | grep -v "^00" | grep -v "99"
		#echo  $claimdata  | cut -c14-

	while read -r claimdata
	do

		claimdata="${claimdata%?}"
		echo ${claimdata:13} >>$tmpfile
		

	done < $infile

	# display contents, skip first and last lines
	cat $tmpfile | tail -n +2 | sed \$d

	rm -f $tmpfile

	
