#!/bin/sh
#
# Program Name	: tr_medsubelig_CHC.sh
# Description	: transfer of MedSub Elig data file to Optum-CHC
# Author	: Linda S. Jefferis
#
# Variables Used:
DATE=`date +%Y%m%d`
SEND_FILE="/usr/lnk/tapes/MEDSUB/PDMIELIG.$DATE.txt"
TR_PROG=/usr/lnk/shell/secure_transfer.sh
TR_ID=CHCOptum
MAIL_PROG=/usr/bin/mutt
MAIL_TO="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tr_medsubelig_CHC.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

RECNT=`wc -l ${SEND_FILE} | awk '{ print $1 }'`

${TR_PROG} ${TR_ID} ${SEND_FILE}
RETVAL="$?"
if [ "$RETVAL" -eq "0" ]
then
	echo -e "The weekly PDMI-CHC data file has been uploaded.\n\nRecord Count = $RECNT" | ${MAIL_PROG} -s "Weekly PDMI-CHC File Upload" ${MAIL_TO}
fi


exit 0

