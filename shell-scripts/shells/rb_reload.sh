#!/bin/ksh
#
# Program Name	: rb_reload.sh
# Description	: Script to run Redbrick Reloads
# Author	: Christina M. Harris
# Date		: 06/06/97
# Modifications :
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rb_reload.sh

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim104.sh -b 6A01A0006D01A000 -o /usr/pdm/tmp/CLWRK00MAS.16-96Y-Q1 -s 16 > ${RPT_DIR}/claim104-1696Q1 2>&1
${SHELL_DIR}/claim104.sh -b 6D01A0006G01A000 -o /usr/pdm/tmp/CLWRK00MAS.16-96Y-Q2 -s 16 > ${RPT_DIR}/claim104-1696Q2 2>&1
${SHELL_DIR}/claim104.sh -b 6G01A0006J01A000 -o /usr/pdm/tmp/CLWRK00MAS.16-96Y-Q3 -s 16 > ${RPT_DIR}/claim104-1696Q3 2>&1
${SHELL_DIR}/claim104.sh -b 6J01A0007A01A000 -o /usr/pdm/tmp/CLWRK00MAS.16-96Y-Q4 -s 16 > ${RPT_DIR}/claim104-1696Q4 2>&1
${SHELL_DIR}/claim104.sh -b 7A01A0007D01A000 -o /usr/pdm/tmp/CLWRK00MAS.16-97Y-Q1 -s 16 > ${RPT_DIR}/claim104-1697Q1 2>&1
${SHELL_DIR}/claim104.sh -b 7D01A0007F02A000 -o /usr/pdm/tmp/CLWRK00MAS.16-97Y-Q2 -s 16 > ${RPT_DIR}/claim104-1697Q2 2>&1

exit 0
