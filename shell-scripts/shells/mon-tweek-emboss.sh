#!/bin/sh
#
# Program Name	: mon-tweek-emboss.sh
# Description	: Monthly - Embossed Cards Reporting
# Author	: Linda S. Jefferis
# Date		: 09/16/2014
# Modifications : 09/29/2014 - Ticket #11688
#		: 01/10/2020 - change "a2ps" to "enscript"
#		: 02/08/2021 - Remove cardh08 process
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

usage: mon-tweek-emboss.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/cardh07.sh -c tweek  > ${RPT_DIR}/cmon-x-cardh07 2>&1

# Convert output files to PDF and email
echo "### cmon-x-cardh07 ###" > ${RPT_DIR}/cmon-x-process
cat ${RPT_DIR}/cmon-x-cardh07 >> ${RPT_DIR}/cmon-x-process
echo "" >> ${RPT_DIR}/cmon-x-process

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/cmon-x-process | ps2pdf - ${RPT_DIR}/cmon-x-process.pdf

echo "Output from mon-tweek-emboss.sh process" | ${MAIL_PROG} -s "Month - ID Card Process" ${MAIL_TO} -a ${RPT_DIR}/cmon-x-process.pdf 

exit 0
