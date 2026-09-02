#!/bin/ksh
#
# Program Name	: email_eft_prod_rpt.sh
# Description	: Email EFT Production listing to Operations Department for archiving to Nova
# Author	: Linda S. Jefferis
# Date		: 05/19/2011
# Modifications : 
#
# Variables Used:
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="ljefferis@pdmi.com"
REMOTE_SYS="prod10"
REMOTE_DIR="/usr/lnk/tmp"
FILE_DIR="/usr/lnk/shares/ftp-tmp"
EFT_RPT="eft-prod-list"
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: email_eft_prod_rpt.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

scp ${REMOTE_SYS}:${REMOTE_DIR}/${EFT_RPT} ${FILE_DIR}/${DATE}-${EFT_RPT}
enscript -rgj --non-printable-format=space -o - ${FILE_DIR}/${DATE}-${EFT_RPT} | ps2pdf - ${FILE_DIR}/${DATE}-${EFT_RPT}.pdf
echo "The report of the updated EFT New Production records is attached." | ${MAIL_PROG} -a ${FILE_DIR}/${DATE}-${EFT_RPT}.pdf -s "EFT Production Report" ${MAIL_TO}

rm -f ${FILE_DIR}/${DATE}-${EFT_RPT}
rm -f ${FILE_DIR}/${DATE}-${EFT_RPT}.pdf

exit 0
