#!/bin/sh


# Program: claim_grepper.sh
# Date: 2012-10-17
# Purpose: Pull raw claims from switch files by batch & claim number
# Claim process type set to "B3" (reverse and process)

usage()
{
	echo "USAGE: $0 [-s] -B1|-B2|-B3 batch_and_claim_file switch_dir "
	echo "example: $0 -B3 bnc_file /usr/lnk/daily/switchfiledir"
	echo "Switch files should be named switchxx-yyyymmdd"
	echo "-s - Skip missing batch and claim records"
	echo "B1 - make transaction a B1"
	echo "B2 - make transaction a B2"
	echo "B3 - make transaction a B3"
}

get_claim()
{


switch_prefix="$1"
filedate="$2"

		datafile="$datadir/$switch_prefix-$filedate"
#		datafile="$datadir/switch40-$filedate.gz $datadir/switch16-$filedate.gz"
	#	echo "Line=383 Q=300 07/25/12 00:00:00.191 Runtime=0 TID=0"

		if [ ! -f "$datafile" ]
		then
			echo "Warning: Switch file $datafile not found" >&2
		else

		rawclaim=`grep $line $datafile`
	echo $rawclaim
		fi
}


# MAIN
FILENAME="UNSET"
SKIP_MISSING="0"
MAKE_B3="0"

if [ "$1" = "-s" ] 
then
	SKIP_MISSING="1"
	shift
fi

CLAIM_TYPE=""

if [ "$1" = "-B1" ] 
then
	CLAIM_TYPE="B1"
	shift
elif [ "$1" = "-B2" ] 
then
	CLAIM_TYPE="B2"
	shift
elif [ "$1" = "-B3" ] 
then
	CLAIM_TYPE="B3"
	shift
else
	usage
	exit 1
fi

DATE=`date +%m%d%y`

	if [ "$#" -ne "2" ]
	then
		usage
		exit 1
	fi
	
	
	infile="$1"
	datadir="$2"

	if [ ! -f "$infile" ]
	then
		echo "File $infile doesn't exist!"
		exit 2
	fi

	if [ ! -d $datadir ]
	then
		echo "File $datadir doesn't exist!"
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
        echo -n "00T           claim_grepper0000000${CDATE}${CTIME}P01                    PDMI"
        echo -e "\003"



	record_count="1"

	for line in `cat "$infile"`
	do
		record_count=`expr $record_count + 1`
		record_count=`printf "%010d" $record_count`

		batch_header="G1${record_count}"
		batch=`echo $line | cut -c1-4`
		filedate=`/usr/lnk/shell/batch2date.sh $batch`
		rawclaim=`get_claim "switch40" $filedate`
		if [ "$rawclaim" = "" ] 
		then
			rawclaim=`get_claim "switch16" $filedate`
		fi
		if [ "$rawclaim" = "" ] 
		then
				# Decrement counter so our record count is right
				record_count=`expr $record_count - 1`
				echo "Batch and claim $line not found" >&2
		else

# Get claim (parse off response from switch file)
		parsed_claim=`echo $rawclaim | awk -F '{ print $1 }'`

# Replace B1 with B3 (reverse and reprocess)
		B3_claim=`echo $parsed_claim | cut -c1-15`
#		echo $B3_claim
		B3_claim="${B3_claim}${CLAIM_TYPE}"
		B3_claim_end=`echo $parsed_claim | cut -c18-`
#		echo $B3_claim_end
		B3_claim="${B3_claim}${B3_claim_end}"

#  Update software certfication field 110-AK with "REPRC"
		parsed_claim="$B3_claim"
#		B3_claim=`echo ${B3_claim} | cut -c54-63`
#		B3_claim=`echo "$parsed_claim" | cut -c1-53`
#		B3_claim_end=`echo "$parsed_claim" | cut -c64-`
#		B3_claim="${B3_claim}REPRC     ${B3_claim_end}"
#  Strip off STX at front.
		B3_claim=`echo "$B3_claim" | cut -c8-`

# Print result to screen
		echo -n -e "\002"
		echo -n $batch_header
		echo -n "$B3_claim"
		echo -e -n "\003\n"

		
		transaction_count="`echo $B3_claim | cut -c 21-21`"


		if [ "$transaction_count" -ne "1" ]
		then
			echo "Warning: Transaction $line multiple claims ($transaction_count)" >&2
			echo $rawclaim | /usr/local/bin/char_repl 28 10 | grep "^F3" | cut -c 3- >&2
		fi

		fi
		


		IFS="$CR"	
	done

	record_count=`expr $record_count + 1`
	record_count=`printf "%010d" $record_count`
	
	echo -e -n  "\002"
	echo -n "990000000${record_count}                                   "
	echo -e "\003"
	
