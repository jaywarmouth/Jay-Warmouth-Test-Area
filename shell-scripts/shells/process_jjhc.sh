#!/bin/sh
#
# Program Name	: process_jjhc.sh
# Description	: Card Production
# Author	: Linda S. Jefferis
# Date		: 10/24/2006
# Modifications : 10/26/2006 - Changed MAIL_TO  (LSJ)
#		: 05/05/2008 - Added secure_transfer.sh  (LSJ)
#		: 06/18/2008 - Removed Jean Masotto email as per request  (LSJ)
#		: 01/14/2009 - Added check_transfer logic  (LSJ)
#		: 02/25/2009 - Changed Trish Matecki email address  (LSJ)
#		: 08/26/2009 - Added Dana.dietz@fiserv.com email  (LSJ)
#		: 12/28/2009 - Replaced Dana.dietx with John.Becks as per email from Trisha  (LSJ)
#		: 03/15/2013 - Added SAMPJJHC file logic
#		: 09/16/2014 - change operations@pdmi.com to cards@pdmi.com
#		: 04/27/2015 - Update MAIL_TO list as per email from JJHC (LSJ)
#		: 09/30/2016 - Change ftp-tmp directory for JJHC_FILE
#		: 02/02/2022 - Change JJHC_FILE and JJHC_DIR
#		: 11/05/2024 - Changed MAIL_TO variable to remove and add addresses and wellas comma seperate to correct no email issue in HALO 0025807
#
# Variables Used:
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="cards@pdmi.com,John.Becks@fiserv.com,linda.malin@fiserv.com,jeff.troxel@fiserv.com"
MAIL_SUBJ="JJHC ID Card File"
DATE=`date +%m%d%y`
JJHC_FILE="/usr/lnk/wt/oper-wt/IDCards/JJHC.TXT"
JJHC_DIR="/usr/lnk/wt/oper-wt/IDCards/Temp"
SAMPJJHC=${JJHC_DIR}/SAMP-JJHC.TXT
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
ID="JG"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: process_jjhc.sh 

ENDOFUSAGE
  exit 1
}

# Check transfer
check_transfer()
{
	echo "\nDid the file transfer okay? y/n :"
        read REPLY
        case $REPLY in
          "y" | "Y")
                rm -f ${JJHC_DIR}/JJHC-${DATE}.TXT
                echo "The file, JJHC-${DATE}.TXT, is available for processing. The record count is $REC_CNT." | ${MAIL_PROG} -s "${MAIL_SUBJ}" ${MAIL_TO} 
		;;
          "n" | "N")
                echo "The /usr/lnk/shell/process_jjhc.sh will need run today manually once connectivity with JG is resolved."
                sleep 5
		;;
          *)  
		echo "Invalid reply:  Please enter y or N for yes, n or N for no"
		counter=`expr $counter + 1`
		if [ $counter = 3 ]
		then
			exit 1	
		else
			check_transfer
		fi
		;;
	esac
}

#
# Main routine
#

if test -s ${JJHC_FILE}
then
	if test -s ${SAMPJJHC}
	then
		cat ${SAMPJJHC} >> ${JJHC_FILE}
		echo "Added sample records to JJHC file"
	fi
	REC_CNT=`wc -l ${JJHC_FILE} | awk '{print $1}'`
	REC_CNT=`expr $REC_CNT - 1`
	cp ${JJHC_FILE} ${JJHC_DIR}/JJHC-${DATE}.TXT
	${TR_PROG} ${ID} ${JJHC_DIR}/JJHC-${DATE}.TXT
	counter=0
	check_transfer
else
	echo "No ${JJHC_FILE} file is available"
	sleep 3
fi


exit 0
