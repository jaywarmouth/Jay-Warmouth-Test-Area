#!/bin/sh
#
# Program Name	: mon-twice-emboss.sh
# Description	: Monthly - Embossed Cards Reporting
# Author	: Linda S. Jefferis
# Date		: 07/05/2005
# Modifications : 01/10/2020 - change "a2ps" to "enscript"
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

usage: mon-twice-emboss.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/cardh07.sh -c twice  > ${RPT_DIR}/cmon-t-cardh07 2>&1

# Convert output files to PDF and email
echo "### cmon-t-cardh07 ###" > ${RPT_DIR}/cmon-t-process
cat ${RPT_DIR}/cmon-t-cardh07 >> ${RPT_DIR}/cmon-t-process
echo "" >> ${RPT_DIR}/cmon-t-process

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/cmon-t-process | ps2pdf - ${RPT_DIR}/cmon-t-process.pdf

echo "Output from mon-twice-emboss.sh process" | ${MAIL_PROG} -s "Month - ID Card Process" ${MAIL_TO} -a ${RPT_DIR}/cmon-t-process.pdf 

exit 0
