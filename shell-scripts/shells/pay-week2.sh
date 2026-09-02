#!/bin/ksh
#
# Program Name	: pay-week2.sh
# Description	: Week-Cycle Update and Report for SummaCare
# Author	: Linda S. Jefferis
# Date		: 01/07/2005
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

usage: pay-week2.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim111su.sh -c week > ${RPT_DIR}/pay-week-claim111su 2>&1
${SHELL_DIR}/tr-week-suma.sh > ${RPT_DIR}/pay-week-tr-suma 2>&1

exit 0
