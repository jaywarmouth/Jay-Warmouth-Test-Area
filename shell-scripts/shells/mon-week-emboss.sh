#!/bin/sh
#
# Program Name	: mon-week-emboss.sh
# Description	: Monthly - Embossed Cards Reporting
# Author	: Linda S. Jefferis
#		: 02/09/2016 - TT13915-19
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mon-week-emboss.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/cardh07.sh -c week  > ${RPT_DIR}/cmon-w-cardh07 2>&1
${SHELL_DIR}/cardh08.sh -c week > ${RPT_DIR}/cmon-w-cardh08 2>&1

# Convert output files to PDF and email
echo "### cmon-w-cardh07 ###" > ${RPT_DIR}/cmon-w-process
cat ${RPT_DIR}/cmon-w-cardh07 >> ${RPT_DIR}/cmon-w-process
echo "" >> ${RPT_DIR}/cmon-w-process
echo "" >> ${RPT_DIR}/cmon-w-process
echo "### cmon-w-cardh08 ###" >> ${RPT_DIR}/cmon-w-process
cat ${RPT_DIR}/cmon-w-cardh08 >> ${RPT_DIR}/cmon-w-process

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/cmon-w-process | ps2pdf - ${RPT_DIR}/cmon-w-process.pdf

echo "Output from mon-week-emboss.sh process" | ${MAIL_PROG} -s "Month - ID Card Process" ${MAIL_TO} -a ${RPT_DIR}/cmon-w-process.pdf 

exit 0
