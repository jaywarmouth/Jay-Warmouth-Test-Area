#!/bin/ksh
#
# Program Name	: tr_tcndc01.sh
# Description	: Removes specified files in arguments
#		  Command Line Arguments:
#		  -d <ccyymmdd> - Alternate file date
# Author	: Linda S. Jefferis
# Date		: 06/09/2010
# Modifications : 12/09/2011 - Changed FILE_DIR and removed ,done file logic
#				new file layout and conversion process
#		: 03/10/2016 - TT13309-6
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date -d "yesterday 0800" +%Y%m%d`
FILE_DIR="/usr/lnk/wt/sqlimports/misc"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="TC"
LOG="/usr/lnk/rpt/tr_tcndc01"
MAIL_PROG=/bin/mail
MAIL_TO=operations@pdmi.com
ARCH="prod11:/usr/lnk/elig_in/sys0078"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tr_tcndc01.sh [-d <ccyymmdd>]
	-d <ccyymmdd>	Alternate file date	(optional)
		By default uses current date

ENDOFUSAGE
  exit 1
}

#
# Set file names
set_filenames()
{
	XML_FILE="${FILE_DIR}/TCNDC-${DATE}.xml"
}


#
# Transfer file
transfer_file()
{
${TR_PROG} ${TR_ID} ${XML_FILE}
if test $? -eq 0
then
	echo "--> Transfer of ${XML_FILE} completed." >> ${LOG}
	scp ${XML_FILE} ${ARCH}
	if test $? -eq 0
	then
		echo "--> ${XML_FILE} is archived to ${ARCH}." >> ${LOG}
		echo "" >> ${LOG}
		rm -f ${XML_FILE}
	else
		echo "-*> Archive of XML file FAILED." >> ${LOG}
		echo "" >> ${LOG}
	fi
else
	echo "-*> File transfer failed." >> ${LOG}
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
	;;
  esac
  shift
done

set_filenames

echo "Transfer Procedure for TCNDC01 file" > ${LOG}
date >> ${LOG}
echo "" >> ${LOG}

if test -s ${XML_FILE}
then
	transfer_file
else
	echo "-*> XML file does not exist." >> ${LOG}
	echo "-*> No file to transfer." >> ${LOG}
        echo "" >> ${LOG}	
fi

date >> ${LOG}
cat ${LOG} | ${MAIL_PROG} -s "Trial Card NDC Transfer" ${MAIL_TO}

exit 0
