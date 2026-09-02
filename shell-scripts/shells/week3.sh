#!/bin/ksh
#
# Program Name	: week3.sh
# Description	: Twice-Cycle Reporting Section
# Author	: Linda S. Jefferis
# Date		: 05/31/2005
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: week3.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim07.sh -c week > ${RPT_DIR}/week-claim07 2>&1
lp ${RPT_DIR}/week-claim07

exit 0
