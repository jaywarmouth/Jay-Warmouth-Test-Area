#!/bin/ksh
#
# Program Name	: process_cards_0553.sh
# Description	: Card Production
# Author	: Linda S. Jefferis
# Date		: 08/15/2008 
# Modifications : 08/21/2008 - Updated the MAIL_TO  (LSJ)
#		: 03/03/2009 - Changed so email is done from Husk  (LSJ)
#		: 09/16/2014 - changed operations@pdmi.com to cards@pdmi.com  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_TO="michael@ancillarymedicalserv.com laura@ancillarymedicalserv.com ashley@ancillarymedicalserv.com"
MAIL_CC="cards@pdmi.com"
DATE=`date +%Y%m%d`
CARD_DIR="/usr/lnk/cards"
CARD_FILE="ABC-0553.TXT"
OUT_DIR="/usr/lnk/wt/anms-wt"
REMOTE_SYS="husk"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: process_cards_0553.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

if test -s ${CARD_DIR}/${CARD_FILE}
then
	REC_CNT=`wc -l ${CARD_DIR}/${CARD_FILE} | awk '{print $1}'`
	REC_CNT=`expr $REC_CNT - 1`
	cp ${CARD_DIR}/${CARD_FILE} ${OUT_DIR}/${DATE}-${CARD_FILE}
	echo "The file, ${DATE}-${CARD_FILE}, is available for processing. The record count is $REC_CNT." | ssh ${REMOTE_SYS} ${MAIL_PROG} -s '"Trinity-0553 ID Card File"' -c ${MAIL_CC} ${MAIL_TO}
else
	echo "No ${CARD_FILE} is available"
fi


exit 0
