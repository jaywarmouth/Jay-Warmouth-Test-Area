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
#		: 02/06/2012 - Removed PREFIX argument logic.
#
# Variables Used:
CR="
"
TAPE_DIR="/usr/lnk/tapes"
FILE_DIR=/usr/lnk/wt/pdm/reconX12
CONFIG_FILE="/usr/local/etc/835_transfer.cfg"
RPT_DIR="/usr/lnk/rpt"
UID_FLAG="null"
SFTP_PROG="/usr/lnk/shell/secure_transfer.sh"
CYCLE="chk"
LET="C"
REMOTE_SYS=husk

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: 835_transfer.sh -i <UID|all>
	-i <UID|all>		(required)

ENDOFUSAGE
  exit 1
}



#
# Transfer procedure
transfer_file()
{
	FILE_CHK=`ls -l ${FILE_DIR}/${CYCLE}/${X12_DIR} | grep "total" | awk '{ print $2 }'`
	if [ "$FILE_CHK" -ne "0" ]
	then
	   echo "METHOD=$METHOD"
	   case ${METHOD} in
	     "PGP"|"HUSKFTP")
		ssh ${REMOTE_SYS} "${SFTP_PROG} ${FID} ${FILE_DIR}/${CYCLE}/${X12_DIR}/*"
		if test $? -ne 0
		then
			echo "-*> Transfer for $FID failed"
		else
			if [ "$EMAILTO" != "NULL" ]
			then
				email_notification "$EMAILTO"
			fi
		fi
		;;
	     "GOANY")
		SOURCE_DIR=${FILE_DIR}/${CYCLE}/${X12_DIR}
		for file in "${SOURCE_DIR}"/*; do
			${SFTP_PROG} ${FID} $file >> ${RPT_DIR}/${CYCLE}-sftp_send
		done
		if [ "$EMAILTO" != "NULL" ]
		then
			email_notification "$EMAILTO"
		fi
		;;
	     *)
		${SFTP_PROG} ${FID} ${FILE_DIR}/${CYCLE}/${X12_DIR}/* >> ${RPT_DIR}/${CYCLE}-sftp_send
		if test $? -ne 0
		then
			echo "-*> Transfer for $FID failed"
		else
			if [ "$EMAILTO" != "NULL" ]
			then	
				email_notification "$EMAILTO" 
			fi
		fi
		;;
	   esac
	   #fi
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
	text="New 835 files have been transferred from PDMI."
	echo $text | /usr/bin/mutt -s "$subject" $to
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
		transfer_file
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
			transfer_file
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
