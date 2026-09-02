#!/bin/ksh
#
# Program Name	: week5.sh
# Description	: Week-Cycle - Payment Reconciliation Files
# Author	: Linda S. Jefferis
# Date		: 05/31/2005
# Modifications : 01/20/2006 - Added second run of reconx12 for independants  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: week5.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/reconx12.sh -c week > ${RPT_DIR}/week-reconx12 2>&1
#lp ${RPT_DIR}/week-reconx12
${SHELL_DIR}/reconx12.sh -c week -i > ${RPT_DIR}/week-reconx12-2 2>&1
#lp ${RPT_DIR}/week-reconx12-2


exit 0
