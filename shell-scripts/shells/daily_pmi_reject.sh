#!/bin/sh
#
# Program Name	: daily_pmi_report.sh
# Description	: Twice-daily process to create PMI Texas Reject Report
# Author	: Linda S. Jefferis
# Date		: 08/31/2011
# Modifications :
#
# Variables Used:
MAIL_PROG="/usr/bin/mutt"
DATE=`date +%Y%m%d-%H%M%S`
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="PMI"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
FLEX="/usr/lnk/flexgen"
RPT_FILE="/usr/lnk/tmp/clapc101.csv"
RPT_NAME="Daily-TX-Report-${DATE}.csv"
MAIL_PMI="rclark@pdmi.com cthornton@pdmi.com"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_pmi_report.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

date 
echo ""
echo "--> Starting report - ohclapc101.cs"
cd ${FLEX}
${FLEX}/ohclapc101.cs

date 

scp ${RPT_FILE} ${REMOTE_SYS}:${REMOTE_DIR}/${RPT_NAME}
#mv ${RPT_FILE} /usr/lnk/tmp/${RPT_NAME}

echo ""
echo "--> Encrypting and transferring file" 
ssh -q ${REMOTE_SYS} "${TR_PROG} ${TR_ID} ${REMOTE_DIR}/${RPT_NAME}"

echo ""
echo "--> Emailing report"
echo "Attached is the latest twice-daily spreadsheet." | ${MAIL_PROG} -a ${RPT_FILE} -s "PMI Twice-Daily Reject Information" ${MAIL_PMI}

echo ""
echo "--> Cleanup"
ssh -q ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${RPT_NAME}"
#rm -f /usr/lnk/tmp/${RPT_NAME}
rm -f ${RPT_FILE}


exit 0
