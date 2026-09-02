#!/bin/ksh
#
# Program Name	: twice-rentnet.sh
# Description	: Twice-Cycle Rented Network Processes
# Author	: Linda S. Jefferis
# Date		: 12/09/2004
# Modifications : 12/01/2006 - Commented out sponsor level run of rentnet02  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
GRP_DIR="/usr/upd/grp"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: twice-rentnet.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

cp ${GRP_DIR}/RENTN00WRK.null ${GRP_DIR}/RENTN00WRK-T
${SHELL_DIR}/rentnet01.sh -c twice -t > ${RPT_DIR}/twice-rentnet01 2>&1
${SHELL_DIR}/rentnet01.sh -c twice -x >> ${RPT_DIR}/twice-rentnet01 2>&1
${SHELL_DIR}/rentnet02.sh -c twice -t > ${RPT_DIR}/twice-rentnet02 2>&1
#${SHELL_DIR}/rentnet02.sh -c twice -x >> ${RPT_DIR}/twice-rentnet02 2>&1

exit 0
