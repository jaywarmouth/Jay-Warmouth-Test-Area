#!/bin/ksh
#
# Program Name	: mon-pay1.sh
# Description	: Month-Cycle - Reports
# Author	: Linda S. Jefferis
# Date		: 02/03/2005
# Modifications :
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mon-pay1.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim56.sh -c pay -m -y > ${RPT_DIR}/mon-p-claim56 2>&1
${SHELL_DIR}/claim57.sh -c pay > ${RPT_DIR}/mon-p-claim57 2>&1
${SHELL_DIR}/claim39.sh -c pay > ${RPT_DIR}/mon-p-claim39 2>&1

exit 0
