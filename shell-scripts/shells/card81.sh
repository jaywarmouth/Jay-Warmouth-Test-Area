#!/bin/ksh
#
# Program Name	: card81.sh
# Description	: Does batch run of cardhup081.sh
# Author	: Linda Jefferis
# Date		: 02/23/2001
# Modifications :
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
TST_DIR="/usr/pdm/tstshl"
RPT_DIR="/usr/pdm/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: card81.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
${SHELL_DIR}/cardhup081.sh > ${RPT_DIR}/cardhup080 2>&1
${TST_DIR}/cardhup081.sh > ${RPT_DIR}/cardhup080.1999 2>&1

exit 0
