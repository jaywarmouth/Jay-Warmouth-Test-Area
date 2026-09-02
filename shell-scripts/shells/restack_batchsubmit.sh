#!/bin/ksh
#
# Program Name	: restack_batchsubmit.sh
# Description	: Script to run the restack batchsubmit process
# Author	: Linda S. Jefferis
# Date		: 03/06/2013
# Modifications	: TT12432-4
#
# Variables Used:
DATE=`date +%Y%m%d`
DATETM=`date +%Y%m%d%H%M%S`
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
NCPDPIN="/usr/lnk/tmp/restack_claims_${DATE}.txt"
RSPFILE="/usr/lnk/tmp/restack_rsp_${DATETM}.txt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: restack_batchsubmit.sh

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

/usr/local/bin/batchsubmit -d 200 514 404 ${NCPDPIN} ${RSPFILE}

scp ${RSPFILE} husk:/usr/lnk/shares/ftp-tmp

#cat ${RPT_DIR}/restack_batchsubmit | ${MAIL_PROG} -s "${HOSTNAME} - Restack Batchsubmit" ${MAIL_TO}

exit 0
