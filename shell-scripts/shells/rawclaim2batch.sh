#!/bin/sh


# Program: rawclaim2batch.sh
# Date: 2012-10-22
# Purpose: Take a file with NCPDP formatted transactions and put them
# into the NCPDP Batch format.  The transaction should not contain any header
# information nor shoudl it be wrapped in <STX><ETX> characters.
# One claim per line. 

usage()
{
	echo "rawclaim2batch version 1.0"
	echo USAGE: $0 claimfile 
}




# MAIN
FILENAME="UNSET"


DATE=`date +%m%d%y`

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

	found="0"

# Generate batch header.
# See http://sharepoint10/development/Programming%20Documents/NCPDP%20Documents/MEDICAID%20SUBROGATION/Batch_imp_guide_v1.2.pdf for more info.

CDATE=`date +%Y%m%d`
CTIME=`date +%H%M`

	echo -e -n  "\002"
	echo -n "00T          rawclaim2batch0000000${CDATE}${CTIME}P01                    PDMI"
	echo -e "\003"

	record_count="1"

	#for rawclaim in `cat $infile`
	while read -r rawclaim
	do
		record_count=`expr $record_count + 1`
		record_count=`printf "%010d" $record_count`

		batch_header="G1${record_count}"
		if [ "$rawclaim" = "" ] 
		then
			echo "Invalid claim"
		else

# Print result to screen
		echo -n -e "\002"
		echo -n $batch_header
		echo -n $rawclaim
		echo -e -n "\003\n"

		fi
		IFS="$CR"	
	done < $infile

	record_count=`expr $record_count + 1`
	record_count=`printf "%010d" $record_count`
	
	echo -e -n  "\002"
	echo -n "990000000${record_count}                                   "
	echo -e "\003"
	
