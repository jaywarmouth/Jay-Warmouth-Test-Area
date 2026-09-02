#!/bin/sh
#
# Program Name	: mon-pay-emboss.sh
# Description	: Monthly - Embossed Cards Reporting
# Author	: Linda S. Jefferis
# Date		: 06/21/96
# Modifications : 05/02/97 - Removed proc_audit  (LSJ)
#		: 10/26/2012 - Added PDF report conversion and emailing
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mon-pay-emboss.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/cardh07.sh -c pay  > ${RPT_DIR}/cmon-p-cardh07 2>&1
${SHELL_DIR}/cardh08.sh -c pay > ${RPT_DIR}/cmon-p-cardh08 2>&1

# Convert output files to PDF and email
echo "### cmon-p-cardh07 ###" > ${RPT_DIR}/cmon-p-process
cat ${RPT_DIR}/cmon-p-cardh07 >> ${RPT_DIR}/cmon-p-process
echo "" >> ${RPT_DIR}/cmon-p-process
echo "" >> ${RPT_DIR}/cmon-p-process
echo "### cmon-p-cardh08 ###" >> ${RPT_DIR}/cmon-p-process
cat ${RPT_DIR}/cmon-p-cardh08 >> ${RPT_DIR}/cmon-p-process

a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/cmon-p-process | ps2pdf - ${RPT_DIR}/cmon-p-process.pdf

echo "Output from mon-pay-emboss.sh process" | ${MAIL_PROG} -s "Month - ID Card Process" ${MAIL_TO} -a ${RPT_DIR}/cmon-p-process.pdf 

exit 0
