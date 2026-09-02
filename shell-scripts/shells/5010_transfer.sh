#!/bin/sh
#
# Program Name	: 835_transfer.sh
# Description	: 
#		  Command Line Arguments:
#		  -i UID|all
# Author	: Linda S. Jefferis
# Date		: 08/20/2006
# Modifications : 01/18/2006 - Added logic to test if files exist before running the secure_transfer.sh procedure and changed to 'script' method to run this.
#		: 01/23/2007 - Added email logic and created sub-processes  (LSJ)
#		: 01/25/2007 - removed 'script' logic  (LSJ)
#		: 05/01/2009 - Changed logic to do transfer_file if METHOD != "CD"  (LSJ)
#		: 09/24/2009 - Changes for switch to new check run process
#		: 02/06/2012 - Removed PREFIX argument logic
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
TAPE_DIR="/usr/lnk/tapes"
TMP_DIR="/tmp"
FILE_DIR=/usr/lnk/shares/ftp-tmp/X12
CONFIG_FILE="/usr/local/pub/temp_5010_transfer.cfg"
RPT_DIR="/usr/lnk/rpt"
UID_FLAG="null"
SFTP_PROG="/usr/lnk/shell/secure_transfer.sh"
CYCLE="v5010"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: 5010_transfer.sh -p <prefix> -i <UID|all>
	-p <prefix> - 3-char p/e date prefix of file  (required)
	-i <UID|all>		(required)

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
	IFS=${EQUAL}
	set $VAR
	NVAR=$1
	export ${NVAR}
        if [ $? -ne 0 ]
        then
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


#
# Transfer procedure
transfer_file()
{
	FILE_CHK=`ls -l ${FILE_DIR}/${CYCLE}/${X12_DIR} | grep "total" | awk '{ print $2 }'`
	if [ "$FILE_CHK" -ne "0" ]
	then
		${SFTP_PROG} ${FID} ${FILE_DIR}/${CYCLE}/${X12_DIR}/* >> ${RPT_DIR}/sftp_send_5010
		if test $? -ne 0
		then
			echo "-*> SFTP for $FID failed"
		else
			if [ "$EMAILTO" != "NULL" ]
			then	
				email_notification "$EMAILTO" 
			fi
		fi
	else
		echo "--> No files for $FID"
	fi
}

#
# Send email notification if required
email_notification()
{
	to="$1"
	subject="PDMI - 835 File Notification"
	text="New parallel V5010 files have been transferred from PDMI."
	echo $text | /bin/mail -s "$subject" $to
	echo "An email notification for $FID has been sent to $to."
}

#
# Parse configuration record
parse_record()
{
	FID=`echo $line | awk -F: '{ print $1 }'`
        X12_DIR=`echo $line | awk -F: '{ print $3 }'`
        METHOD=`echo $line | awk -F: '{ print $4 }'`
        TEXT_FLAG=`echo $line | awk -F: '{ print $5 }'`
        EMAILTO=`echo $line | awk -F: '{ print $7}'`
        CHAIN_LIST=`echo $line | awk -F: '{ print $8 }'`
}

# transfer all files
sftp_file_all()
{
	IFS="$CR"
	for line in `cat $CONFIG_FILE | grep -v "^#"`
	do
		IFS="$OIFS"
		parse_record
		#if [ $METHOD = "SFTP" ]
		if [ $METHOD != "CD" ]
		then
			transfer_file
		fi
	done
}

# Transfer one uid files
sftp_file_uid()
{
	IFS="$CR"
	FOUND="0"
        for line in `cat $CONFIG_FILE | grep -v "^#"`
        do
		IFS="$OIFS"	
		parse_record
		if [ "$UID_FLAG" = "$FID" ]
		then
			FOUND="1"
			#if [ $METHOD = "SFTP" ]
			if [ $METHOD != "CD" ]
			then
				transfer_file
			else
				echo "-*> $FID is not setup to transfer files"
			fi
		fi
	done
	if [ "$FOUND" -ne "1" ]
	then
		echo "*-> ID $UID_FLAG is not found in database"
		exit 1
	fi
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
	usage
	exit 1
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	UID_FLAG=$1
	;;
  esac
  shift
done

if [ "$UID_FLAG" = "null" ]
then
	usage
fi

if [ "$UID_FLAG" = "all" ]
then
	sftp_file_all
else
	sftp_file_uid
fi

exit 0
