#!/bin/sh
#
# Program Name	: tweek2.sh
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

usage: tweek2.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

if test -e /usr/upd/grp/INLGWRKMAS-X
then
        rm -f /usr/upd/grp/INLGWRKMAS-X
fi
if test -e /usr/upd/grp/SUSPWRKMAS-X
then
        rm -f /usr/upd/grp/SUSPWRKMAS-X
fi

${SHELL_DIR}/claim16.sh -c tweek -i sys > ${RPT_DIR}/tweek-claim16 2>&1
${SHELL_DIR}/claim16.sh -c tweek -i spo -s >> ${RPT_DIR}/tweek-claim16 2>&1
${SHELL_DIR}/claim16.sh -c tweek -i grp -s >> ${RPT_DIR}/tweek-claim16 2>&1


# Convert output files to PDF and email
echo "### tweek-claim16 ###" > ${RPT_DIR}/tweek-tweek2
cat ${RPT_DIR}/tweek-claim16 >> ${RPT_DIR}/tweek-tweek2

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/tweek-tweek2 | ps2pdf - ${RPT_DIR}/tweek-tweek2.pdf
enscript -Rgj --non-printable-format=space -o - ${MISC_DIR}/???CL16-SYS-INV-X | ps2pdf - ${RPT_DIR}/tweek-sys-totals.pdf
cp ${MISC_DIR}/???CL16-SYS-INVTOT-X ${RPT_DIR}/tweek-totals.csv

echo "Output from tweek2.sh process" | ${MAIL_PROG} -s "TWeek-cycle - tweek2" ${MAIL_TO} -a ${RPT_DIR}/tweek-tweek2.pdf -a ${RPT_DIR}/tweek-sys-totals.pdf -a ${RPT_DIR}/tweek-totals.csv

exit 0
