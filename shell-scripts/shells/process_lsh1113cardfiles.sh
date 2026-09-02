#!/bin/sh
#
# Program Name	: process_lsh1113cardfiles.sh
#
# Modifications : Changed MAIL_TO variable to remove and add addresses and wellas comma seperate to correct no email issue in HALO 0025807
#
# Variables Used:
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="cards@pdmi.com,linda.malin@fiserv.com,jeff.troxel@fiserv.com"
MAIL_SUBJ="EYLEA ID Card File"
DATE=`date +%Y%m%d`
CRDFILE="/usr/lnk/wt/oper-wt/IDCards/LSH-1113.TXT"
TEMPDIR="/usr/lnk/wt/oper-wt/IDCards/Temp"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
ID="JG"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: process_lsh1113cardfiles.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

if test -s ${CRDFILE}
then
	REC_CNT=`wc -l ${CRDFILE} | awk '{print $1}'`
	REC_CNT=`expr $REC_CNT - 1`
	cp ${CRDFILE} ${TEMPDIR}/${DATE}-EYLEA.TXT
	${TR_PROG} ${ID} ${TEMPDIR}/${DATE}-EYLEA.TXT
	echo "The file, ${DATE}-EYLEA.TXT, is available for processing. The record count is $REC_CNT." | ${MAIL_PROG} -s "${MAIL_SUBJ}" ${MAIL_TO}
else
	echo "No ${CRDFILE} file is available"
	RETVAL=99
fi
rm -f ${TEMPDIR}/${DATE}-EYLEA.TXT


exit ${RETVAL}
