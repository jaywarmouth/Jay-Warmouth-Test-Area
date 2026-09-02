#!/bin/ksh
#
# Program Name	: calmon-claim34.sh
# Description	: Calendar Month-Cycle - Reports
# Author	: Linda S. Jefferis
# Date		: 04/05/99
# Modifications : 05/28/99 - system input changed from 2 to 4-digits
#		: 07/17/00 - Removed sys49 run to match reports needed  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
#SHELL_DIR="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: calmon-claim34.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim34.sh -c pay -r 0043 > /usr/lnk/rpt/claim34.sys43 2>&1
${SHELL_DIR}/claim34.sh -c pay -r 0049 > /usr/lnk/rpt/claim34.sys49 2>&1

exit 0
