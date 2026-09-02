#!/bin/ksh
#
# Program Name	: odohs2.sh
# Description   : Monthly ODOHS Update 
# Author	: Linda S. Jefferis
# Date		: 12/17/96
# Modifications : 08/26/97 (LSJ) Took out proc_audit and RUNPATH
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: odohs2.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#
# Check command line validity, call usage if incorrect

${SHELL_DIR}/drug017.sh -p -t "2127" > ${RPT_DIR}/drug017.2127 2>&1
#lpp ${RPT_DIR}/drug017.2127
${SHELL_DIR}/drug017.sh -p -t "2430" > ${RPT_DIR}/drug017.2430 2>&1
#lpp ${RPT_DIR}/drug017.2430

exit 0
