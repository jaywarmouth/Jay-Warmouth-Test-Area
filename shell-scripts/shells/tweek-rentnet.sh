#!/bin/ksh
#
# Program Name	: tweek-rentnet.sh
# Description	: Tweek-Cycle Rented Network Processes
# Author	: Linda S. Jefferis
# Date		: 09/16/2010
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
GRP_DIR="/usr/upd/grp"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tweek-rentnet.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

cp ${GRP_DIR}/RENTN00WRK.null ${GRP_DIR}/RENTN00WRK-X
${SHELL_DIR}/rentnet01.sh -c tweek -t > ${RPT_DIR}/tweek-rentnet01 2>&1
${SHELL_DIR}/rentnet02.sh -c tweek -t > ${RPT_DIR}/tweek-rentnet02 2>&1

exit 0
