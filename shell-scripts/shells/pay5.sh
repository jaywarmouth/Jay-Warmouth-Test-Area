#!/bin/ksh
#
# Program Name	: pay5.sh
# Description	: Pay-Cycle Reporting Section - Payment Reconciliation Files
# Author	: Linda S. Jefferis
# Date		: 10/09/2003
# Modifications : 01/20/2006 - Added second run of reconx12 for independants  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pay5.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/reconx12.sh -c pay > ${RPT_DIR}/pay-reconx12 2>&1
#lp ${RPT_DIR}/pay-reconx12
${SHELL_DIR}/reconx12.sh -c pay -i > ${RPT_DIR}/pay-reconx12-2 2>&1
#lp ${RPT_DIR}/pay-reconx12-2

exit 0
