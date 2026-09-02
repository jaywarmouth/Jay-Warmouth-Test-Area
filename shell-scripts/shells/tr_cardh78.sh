#!/bin/ksh
#
# Program Name	: tr_cardh78.sh.sh
# Description	: Removes specified files in arguments
#		  Command Line Arguments:
#		  -d <ccyymmdd> - Alternate file date
# Author	: Linda S. Jefferis
# Date		: 05/29/2009
# Modifications : 07/06/2009 - Added "-d" option
#		: 08/18/2009 - Add archive of XML files
#		: 12/13/2011 - Added logic to change date on transferred file to "yesterday"
#		: 03/10/2016 - TT13309-6
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%Y%m%d`
YESTERDAY=`date -d "yesterday 0800" +%Y%m%d`
FILE_DIR="/usr/lnk/shares/ftp-tmp"
ZIP_PROG="/usr/bin/zip"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="TC"
LOG="/usr/lnk/rpt/tr_cardh78"
MAIL_PROG=/bin/mail
MAIL_TO=operations@pdmi.com
ARCH="prod11:/usr/lnk/elig_in/sys0078"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tr_cardh78.sh.sh [-d <ccyymmdd>]
	-d <ccyymmdd>	Alternate file date	(optional)
		By default uses current date

ENDOFUSAGE
  exit 1
}

#
# Set file names
set_filenames()
{
	CARDH78_FILE="${FILE_DIR}/CARDH78TAP-${DATE}"
	DONE_FILE="${FILE_DIR}/CARDH78TAP-${DATE}.done"
	XML_FILE="${FILE_DIR}/CARDH78TAP-${DATE}.xml"
	NEW_XML_FILE=${FILE_DIR}/CARDH78TAP-${YESTERDAY}.xml
	ZIP_FILE="${FILE_DIR}/MemRecord_${YESTERDAY}.zip"
}

#
# Validate file
validate_file()
{
	IN_RC=`grep "RECORD COUNT:" $CARDH78_FILE | awk -F"|" '{ print $1 }' | awk '{ print $3 }'`
	OUT_RC=`grep "<MemberRecord>" $NEW_XML_FILE | wc -l`
	if [ $IN_RC = $OUT_RC ]
	then
		echo "--> Record counts validated." >> ${LOG}
		echo "" >> ${LOG}
		transfer_file
	else
		echo "-*> Record Counts do not equal" >> ${LOG}
		echo "" >> ${LOG}
	fi
}

#
# Zip and Transfer file
transfer_file()
{
	${ZIP_PROG} -jm ${ZIP_FILE} ${NEW_XML_FILE}
	if test $? -eq 0
	then
		echo "--> Zip of ${NEW_XML_FILE} completed." >> ${LOG}
		echo "" >> ${LOG}
		rm -f ${CARDH78_FILE}
        	${TR_PROG} ${TR_ID} ${ZIP_FILE}
		if test $? -eq 0
		then
			echo "--> Transfer of ${ZIP_FILE} completed." >> ${LOG}
			scp ${ZIP_FILE} ${ARCH}
			if test $? -eq 0
			then
				echo "--> ${ZIP_FILE} is archived to ${ARCH}." >> ${LOG}
				echo "" >> ${LOG}
				rm -f ${ZIP_FILE}
			else
				echo "-*> Archive of ZIP file FAILED." >> ${LOG}
				echo "" >> ${LOG}
			fi
		else
			echo "-*> File transfer failed." >> ${LOG}
			echo "" >> ${LOG}
		fi
	else
		echo "-*> The zip of ${NEW_XML_FILE} failed." >> ${LOG}
		echo "" >> ${LOG}
	fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	DATE=$1
	YESTERDAY=`date -d "yesterday $DATE 0800" +%Y%m%d`
	;;
  esac
  shift
done

set_filenames

echo "Transfer Procedure for cardh78 file" > ${LOG}
date >> ${LOG}
echo "" >> ${LOG}

if test -e ${DONE_FILE}
then
	i=0
	while [ $i -le 10 ]
	do
		sleep 1m
		if test -e ${DONE_FILE}
		then
			let i=i+1
		else
			i=6
		fi
	done
else
	if test -s ${XML_FILE}
	then
		mv ${XML_FILE} ${NEW_XML_FILE}
		validate_file
	else
		echo "-*> No XML file found. No file transferred." >> ${LOG}
		echo "" >> ${LOG}
	fi
fi

date >> ${LOG}
cat ${LOG} | ${MAIL_PROG} -s "Trial Card CARDH78 Transfer" ${MAIL_TO}

exit 0
