#!/bin/ksh
#
# Program Name	: mon-pay2.sh
# Description	: Month-Cycle - Reports
# Author	: Linda S. Jefferis
# Date		: 06/21/96
# Modifications : 04/01/99 - Removed claim72 run  (LSJ)
#		: 06/28/2001 - Removed claim109 and claim94 runs  (LSJ)
#		: 11/24/2004 - eliminated the sys run of claim13 and spo run of claim38  (LSJ)
#		: 02/03/3006 - Added claim34 to this procedure  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
TSTSHL_DIR="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mon-pay2.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim11.sh -c pay > ${RPT_DIR}/mon-p-claim11 2>&1
${SHELL_DIR}/claim13.sh -l spo -c pay > ${RPT_DIR}/mon-p-claim13 2>&1
${SHELL_DIR}/claim13.sh -l grp -c pay >> ${RPT_DIR}/mon-p-claim13 2>&1
${SHELL_DIR}/claim13.sh -l sub -c pay >> ${RPT_DIR}/mon-p-claim13 2>&1
${SHELL_DIR}/claim36.sh -c pay > ${RPT_DIR}/mon-p-claim36 2>&1
${SHELL_DIR}/claim31.sh -c pay > ${RPT_DIR}/mon-p-claim31 2>&1
${SHELL_DIR}/claim32.sh -c pay > ${RPT_DIR}/mon-p-claim32 2>&1
${SHELL_DIR}/claim34.sh -c pay > ${RPT_DIR}/mon-p-claim34 2>&1

exit 0
