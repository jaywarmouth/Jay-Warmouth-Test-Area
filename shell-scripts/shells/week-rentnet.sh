#!/bin/ksh
#
# Program Name	: week-rentnet.sh
# Description	: week-Cycle Rented Network Processes
# Author	: Linda S. Jefferis
# Date		: 06/27/2005
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

usage: week-rentnet.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

cp ${GRP_DIR}/RENTN00WRK.null ${GRP_DIR}/RENTN00WRK-W
${SHELL_DIR}/rentnet01.sh -c week -t > ${RPT_DIR}/week-rentnet01 2>&1
${SHELL_DIR}/rentnet02.sh -c week -t > ${RPT_DIR}/week-rentnet02 2>&1

exit 0
