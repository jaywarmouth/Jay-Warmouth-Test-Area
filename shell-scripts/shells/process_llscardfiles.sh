#!/bin/sh
#
# Program Name	: process_llscardfiles.sh
#
# Modifications : Changed MAIL_TO variable to remove and add addresses and well as comma seperate to correct no email issue in HALO 0025807
#
# Variables Used:
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="cards@pdmi.com,linda.malin@fiserv.com,jeff.troxel@fiserv.com"
MAIL_SUBJ="PAF-LLS ID Card File"
DATE=`date +%Y%m%d`
LLS_FILE="/usr/lnk/wt/oper-wt/IDCards/PAF-LLS.TXT"
LLS_DIR="/usr/lnk/wt/oper-wt/IDCards/Temp"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
ID="JG"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: process_llscardfiles.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

if test -s ${LLS_FILE}
then
	REC_CNT=`wc -l ${LLS_FILE} | awk '{print $1}'`
	REC_CNT=`expr $REC_CNT - 1`
	cp ${LLS_FILE} ${LLS_DIR}/${DATE}-PAF-LLS.TXT
	${TR_PROG} ${ID} ${LLS_DIR}/${DATE}-PAF-LLS.TXT
	echo "The file, ${DATE}-PAF-LLS.TXT, is available for processing. The record count is $REC_CNT." | ${MAIL_PROG} -s "${MAIL_SUBJ}" ${MAIL_TO}
else
	echo "No ${LLS_FILE} file is available"
	RETVAL=99
fi
rm -f ${LLS_DIR}/${DATE}-PAF-LLS.TXT


exit ${RETVAL}
