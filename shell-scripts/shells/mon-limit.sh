#!/bin/ksh
#
# Program Name	: mon-limit.sh
# Description	: Monthly - Limit Procedure for HRRX
# Author	: Linda S. Jefferis
# Date		: 06/01/98
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mon-limit.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/limit11.sh  > ${RPT_DIR}/limit11 2>&1
lp ${RPT_DIR}/limit11
${SHELL_DIR}/claim19.sh -l D ljefferi > ${RPT_DIR}/claim19.limit 2>&1

exit 0
