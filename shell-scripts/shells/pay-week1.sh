#!/bin/ksh
#
# Program Name	: pay-week1.sh
# Description	: Week-Cycle Update and Report for pay-cycle week
# Author	: Linda S. Jefferis
# Date		: 10/29/2003
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pay-week1.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim113.sh -w > ${RPT_DIR}/pay-claim113 2>&1
${SHELL_DIR}/tr-cl113.sh > ${RPT_DIR}/pay-tr-cl113 2>&1

exit 0
