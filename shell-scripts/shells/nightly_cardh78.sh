#!/bin/sh
#
# Program Name	: nightly_cardh78.sh
# Description	: Nightly TrialCard-cardh78 Processing 
# Author	: Linda S. Jefferis
# Date		: 05/28/2009
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_TO=operations@pdmi.com
FULL_DATE=`date +%Y%m%d`
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
FILE_DIR="/usr/lnk/tapes"
ARCH_DIR="/usr/lnk/elig_in_1/sys0078"
CARDH78_FILE="CARDH78TAP-${FULL_DATE}"
LOG="$RPT_DIR/nightly_cardh78"
TR_SCRIPT="/usr/lnk/shell/tr_cardh78.sh"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: nightly_cardh78.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/cardh78.sh > ${LOG} 2>&1 

echo "--> Converting and transferring file on Remote" >> ${LOG}
if test -s ${FILE_DIR}/${CARDH78_FILE}
then
	touch ${FILE_DIR}/${CARDH78_FILE}.done
	scp ${FILE_DIR}/${CARDH78_FILE} ${REMOTE_SYS}:${REMOTE_DIR}
	scp ${FILE_DIR}/${CARDH78_FILE}.done ${REMOTE_SYS}:${REMOTE_DIR}
	ssh ${REMOTE_SYS} "echo "${TR_SCRIPT}" | at 6am today"
	echo "File archived to ${ARCH_DIR}" >> ${LOG}
	mv ${FILE_DIR}/${CARDH78_FILE} ${ARCH_DIR}
	rm -f ${FILE_DIR}/${CARDH78_FILE}.done
else
	echo "-*> No ${CARDH78_FILE} file..." >> ${LOG}
fi

cat ${LOG} | ${MAIL_PROG} -s "Daily CARDH78 Process" ${MAIL_TO}


exit 0
