#!/bin/sh
#
# Program Name	: chk-clmext003.sh
# Description	: Check Run clmext003 Procedure
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
CLWRK="/usr/lnk/tmp/CLWRK00MAS.chk"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
FIN_DIR="/usr/lnk/wt/finance"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: chk-clmext003.sh

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

PD_DATE=$1
PREFIX=$2

${SHELL_DIR}/clmext003.sh -i ${CLWRK} -o ${FIN_DIR}/feeclmextract-${PD_DATE}.csv -r ${PREFIX}X000000001${PREFIX}Z999999999 > ${RPT_DIR}/chk-clmext003 2>&1
echo "" >> ${RPT_DIR}/chk-clmext003
cat ${RPT_DIR}/chk-clmext003 | ${MAIL_PROG} -s "Check Run - clmext003" ${MAIL_TO}

exit 0
