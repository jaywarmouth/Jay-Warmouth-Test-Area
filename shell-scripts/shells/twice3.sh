#!/bin/ksh
#
# Program Name	: twice3.sh
# Description	: Twice-Cycle Reporting Section
# Author	: Linda S. Jefferis
# Date		: 12/09/2004
# Modifications : 01/09/2006 - no longer running lim12 for spo0287  (LSJ)
#		: 08/06/2009 - as per Ranada, no longer need limit12 for spo0283 either  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: twice3.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim07.sh -c twice > ${RPT_DIR}/twice-claim07 2>&1
lp ${RPT_DIR}/twice-claim07
#${SHELL_DIR}/limit12.sh > ${RPT_DIR}/twice-limit12 2>&1
#${SHELL_DIR}/limit12.sh -m > ${RPT_DIR}/twice-limit12 2>&1

exit 0
