#!/bin/sh
#
# Program Name	: email_phdem_rpt.sh
# Description	: Email PHDEM-SEP CHK-IND CODE listing to Pharmacy Department
# Author	: Linda S. Jefferis
# Date		: 05/01/2009
# Modifications : 01/14/2013 - Added ntyler@pdmi.com to MAIL_TO
#		: 08/08/2014 - replace ntyler email with escalationteam (TT:11704-2)(DME)
#		: 01/12/2020 - changed "a2ps" to "enscript"
# Variables Used:
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="pharmacy@pdmi.com escalationteam@pdmi.com"
MAIL_CC="operations@pdmi.com"
REMOTE_SYS="prod10"
REMOTE_DIR="/usr/lnk/tmp"
FILE_DIR="/usr/lnk/shares/ftp-tmp"
PHDEM_RPT="phdem-rpt"
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: email_phdem_rpt.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

scp ${REMOTE_SYS}:${REMOTE_DIR}/${PHDEM_RPT} ${FILE_DIR}
enscript -rBj -a2- -o - ${FILE_DIR}/${PHDEM_RPT} | ps2pdf - ${FILE_DIR}/${DATE}-${PHDEM_RPT}.pdf
echo "The report of the updated PHDEM Sep Chk/Ind Code records is attached." | ${MAIL_PROG} -a ${FILE_DIR}/${DATE}-${PHDEM_RPT}.pdf -s "PHDEM Report" -c ${MAIL_CC} ${MAIL_TO}

rm -f ${FILE_DIR}/${PHDEM_RPT} ${FILE_DIR}/${DATE}-${PHDEM_RPT}

exit 0
