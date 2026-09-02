#!/bin/ksh
#
# Program Name	: pay-urx-mkt.sh
# Description	: Pay-Cycle URX Marketing Fee Special Procedures
# Author	: Linda S. Jefferis
# Date		: 10/26/2005
# Modifications :
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pay-urx-mkt.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim120.sh -c pay > ${RPT_DIR}/pay-claim120 2>&1
${SHELL_DIR}/invoice02.sh -c pay -x 00000295 > ${RPT_DIR}/pay-invoice02 2>&1

exit 0
