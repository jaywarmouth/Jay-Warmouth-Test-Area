#!/bin/bash
#
# Program Name	: duptherapy.sh
# Description	: 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
PATH=/usr/rmcobol:/usr/local/bin:$PATH

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: duptherapy.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

# Check command line validity, call usage if incorrect

${SHELL_DIR}/dtdcup001.sh > ${RPT_DIR}/duptherapy 2>&1
${SHELL_DIR}/dtdgup001.sh >> ${RPT_DIR}/duptherapy 2>&1
${SHELL_DIR}/dtdgpiup001.sh >> ${RPT_DIR}/duptherapy 2>&1

cat ${RPT_DIR}/duptherapy | ${MAIL_PROG} -s "Monthly DupTherapy" ${MAIL_TO}

exit 0
