#!/bin/sh
#
# Program Name	: twice2.sh
# Description	: Tweek-Cycle Reporting Section
# Author	: Linda S. Jefferis
# Date		: 09/16/2010
# Modifications : 10/01/2011 - Add email PDF logic
#               : 12/30/2015 - TT8641-32; logic for new CSV file  (LSJ)
#		: TT13915-64 - removal of rentnet procedures
#		: 11/12/2019 - Change "a2ps" to "enscript"
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: twice2.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

if test -e /usr/upd/grp/INLGWRKMAS-T
then
        rm -f /usr/upd/grp/INLGWRKMAS-T
fi
if test -e /usr/upd/grp/SUSPWRKMAS-T
then
        rm -f /usr/upd/grp/SUSPWRKMAS-T
fi

${SHELL_DIR}/claim16.sh -c twice -i sys > ${RPT_DIR}/twice-claim16 2>&1
${SHELL_DIR}/claim16.sh -c twice -i spo -s >> ${RPT_DIR}/twice-claim16 2>&1
${SHELL_DIR}/claim16.sh -c twice -i grp -s >> ${RPT_DIR}/twice-claim16 2>&1


# Convert output files to PDF and email
echo "### twice-claim16 ###" > ${RPT_DIR}/twice-twice2
cat ${RPT_DIR}/twice-claim16 >> ${RPT_DIR}/twice-twice2

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/twice-twice2 | ps2pdf - ${RPT_DIR}/twice-twice2.pdf
enscript -Rgj --non-printable-format=space -o - ${MISC_DIR}/???CL16-SYS-INV-T | ps2pdf - ${RPT_DIR}/twice-sys-totals.pdf
cp ${MISC_DIR}/???CL16-SYS-INVTOT-T ${RPT_DIR}/twice-totals.csv

echo "Output from twice2.sh process" | ${MAIL_PROG} -s "Twice-cycle - twice2" ${MAIL_TO} -a ${RPT_DIR}/twice-twice2.pdf -a ${RPT_DIR}/twice-sys-totals.pdf -a ${RPT_DIR}/twice-totals.csv

exit 0
