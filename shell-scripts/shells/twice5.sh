#!/bin/ksh
#
# Program Name	: twice5.sh
# Description	: Twice-Cycle - Payment Reconciliation Files
# Author	: Linda S. Jefferis
# Date		: 12/09/2004
# Modifications : 01/20/2006 - Added second run of reconx12 for independants  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: twice5.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/reconx12.sh -c twice > ${RPT_DIR}/twice-reconx12 2>&1
#lp ${RPT_DIR}/twice-reconx12
${SHELL_DIR}/reconx12.sh -c twice -i > ${RPT_DIR}/twice-reconx12-2 2>&1
#lp ${RPT_DIR}/twice-reconx12-2

exit 0
