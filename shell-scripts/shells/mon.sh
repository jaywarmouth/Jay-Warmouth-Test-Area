#!/bin/ksh
#
# Program Name	: mon.sh
# Description	: Month-Cycle - Reports
# Author	: Linda S. Jefferis
# Date		: 06/21/96
# Modifications : 04/01/99 - Removed claim72 run  (LSJ)
#		: 06/28/2001 - Removed claim109 and claim94 runs  (LSJ)
#		: 11/24/2004 - eliminated the sys run of claim13 and spo run of claim38  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
TSTSHL_DIR="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mon.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim11.sh  > ${RPT_DIR}/mon-claim11 2>&1
#${SHELL_DIR}/claim13.sh -l sys > ${RPT_DIR}/mon-claim13 2>&1
${SHELL_DIR}/claim13.sh -l spo > ${RPT_DIR}/mon-claim13 2>&1
${SHELL_DIR}/claim13.sh -l grp >> ${RPT_DIR}/mon-claim13 2>&1
${SHELL_DIR}/claim13.sh -l sub >> ${RPT_DIR}/mon-claim13 2>&1
${SHELL_DIR}/claim36.sh  > ${RPT_DIR}/mon-claim36 2>&1
#${SHELL_DIR}/claim38.sh -l spo > ${RPT_DIR}/mon-claim38 2>&1
${SHELL_DIR}/claim38.sh -l grp > ${RPT_DIR}/mon-claim38 2>&1
${SHELL_DIR}/claim31.sh > ${RPT_DIR}/mon-claim31 2>&1
${SHELL_DIR}/claim32.sh  > ${RPT_DIR}/mon-claim32 2>&1

exit 0
