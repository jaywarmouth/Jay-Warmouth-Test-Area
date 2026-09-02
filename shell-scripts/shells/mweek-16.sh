#!/bin/ksh
#
# Program Name	: mweek-16.sh
# Description	: MEDD Week - Invoice procedures
# Author	: Linda S. Jefferis
# Date		: 12/14/2009
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
CYCLE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mweek-16.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#


${SHELL_DIR}/claim16.sh -c twice -m -i sys > ${RPT_DIR}/mweek-claim16 2>&1
${SHELL_DIR}/claim16.sh -c twice -m -i spo -s >> ${RPT_DIR}/mweek-claim16 2>&1

exit 0
