#!/bin/sh
#
# Program Name	: daily_clms_ngs.sh
# Description	: Nightly Claims File Processing 
# Author	: Linda S. Jefferis
# Date		: 09/05/2007
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_TO=operations@pdmi.com
FILE_DATE=`date -d "yesterday" +%Y%m%d`
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
FILE_DIR="/usr/lnk/daily/sc"
CLM_FILE="CLMRT-${FILE_DATE}"
NEW_FILE="${REMOTE_DIR}/NGS_CLMS_${FILE_DATE}"
LOG="$RPT_DIR/daily_clms_ngs"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
TR_ID="NGS"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_clms_ngs.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

echo `date` > ${LOG}

if test -s ${FILE_DIR}/${CLM_FILE}
then
	echo "--> Copying file to ${REMOTE_SYS}" >> ${LOG}
	scp -q ${FILE_DIR}/${CLM_FILE} ${REMOTE_SYS}:${NEW_FILE}
else
	echo "--> Copying empty file to ${REMOTE_SYS}" >> ${LOG}
	echo "No claims for today" > ${FILE_DIR}/${CLM_FILE}
	chmod 666 ${FILE_DIR}/${CLM_FILE}
	scp -q ${FILE_DIR}/${CLM_FILE} ${REMOTE_SYS}:${NEW_FILE}
fi

echo "--> Encrypting and transferring file" >> ${LOG}
ssh -q ${REMOTE_SYS} "${TR_PROG} ${TR_ID} ${NEW_FILE}" >> ${LOG}

echo "--> Cleanup" >> ${LOG}
ssh -q ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${NEW_FILE}" >> ${LOG}

echo `date` >> ${LOG}

cat ${LOG} | ${MAIL_PROG} -s "Daily NGS Claims Process" ${MAIL_TO}


exit 0
