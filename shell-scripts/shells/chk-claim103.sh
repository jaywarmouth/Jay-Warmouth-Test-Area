#!/bin/sh
#
# Program Name	: chk-claim103.sh
# Description	: Check Run claim103 Procedure
# Author	: Linda S. Jefferis
# Date		: 02/23/2005
# Modifications : 11/12/2010 - Add email of results output
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
CLWRK="/usr/lnk/tmp/CLWRK00MAS.chk"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: chk-claim103.sh

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

if test -e ${CLWRK}
then
	rm -f ${CLWRK}
fi
${SHELL_DIR}/claim103.sh -o ${CLWRK} > ${RPT_DIR}/chk-claim103 2>&1
bak ${CLWRK}
echo "" >> ${RPT_DIR}/chk-claim103
ls -l $CLWRK >> ${RPT_DIR}/chk-claim103
cat ${RPT_DIR}/chk-claim103 | ${MAIL_PROG} -s "Check Run - Claim103" ${MAIL_TO}

exit 0
