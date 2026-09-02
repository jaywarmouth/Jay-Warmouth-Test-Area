#!/bin/sh
#
# Process Name	: process_myocardfiles.sh
#
# Modifications : Changed MAIL_TO variable to remove and add addresses and wellas comma seperate to correct no email issue in HALO 0025807
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="cards@pdmi.com,linda.malin@fiserv.com,jeff.troxel@fiserv.com"
MAIL_SUBJ="MyoDerm ID Card File"
DATE=`date +%Y%m%d`
CARD_DIR="/usr/lnk/wt/oper-wt/IDCards"
MYO_FILES="MYO-????.TXT"
MYO_DIR="/usr/lnk/wt/oper-wt/IDCards/Temp"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
ID="JG"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: process_myocardfiles.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

for file in `ls -1 ${CARD_DIR}/${MYO_FILES}`
do
	myofile=`basename $file`
	REC_CNT=`wc -l ${file} | awk '{print $1}'`
	REC_CNT=`expr $REC_CNT - 1`
	cp ${CARD_DIR}/${myofile} ${MYO_DIR}/${DATE}-${myofile}
	${TR_PROG} ${ID} ${MYO_DIR}/${DATE}-${myofile}
	echo "The file, ${DATE}-${myofile}, is available for processing. The record count is $REC_CNT." | ${MAIL_PROG} -s "${MAIL_SUBJ}" ${MAIL_TO}
	rm -f ${MYO_DIR}/${DATE}-${myofile}
done



exit ${RETVAL}
