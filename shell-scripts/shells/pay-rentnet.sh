#!/bin/ksh
#
# Program Name	: pay-rentnet.sh
# Description	: Pay-Cycle Rented Network Processes
# Author	: Linda S. Jefferis
# Date		: 04/25/2002
# Modifications : 05/29/03 - Added "pay-" to names of rpt files  (LSJ)
#		: 08/13/2003 - Added sys and spo runs of rentnet01  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
GRP_DIR="/usr/upd/grp"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pay-rentnet.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

cp ${GRP_DIR}/RENTN00WRK.null ${GRP_DIR}/RENTN00WRK-P
${SHELL_DIR}/rentnet01.sh -c pay -t > ${RPT_DIR}/pay-rentnet01 2>&1
${SHELL_DIR}/rentnet01.sh -c pay -x >> ${RPT_DIR}/pay-rentnet01 2>&1
${SHELL_DIR}/rentnet02.sh -c pay -t > ${RPT_DIR}/pay-rentnet02 2>&1
${SHELL_DIR}/rentnet02.sh -c pay -x >> ${RPT_DIR}/pay-rentnet02 2>&1

exit 0
