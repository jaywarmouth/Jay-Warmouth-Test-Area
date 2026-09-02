#!/bin/sh
#
# Program Name	: week2.sh
# Description	: Week-Cycle Reporting Section
# Author	: Linda S. Jefferis
# Date		: 05/31/2005
# Modifications : 06/29/2009 - Commented the claim44 procedure; now created through RS
#		: 09/18//2009 - Updates for switch to new check run process
#		: 03/24/2011 - Removed claim09 and claim12 processes
#		: 04/05/2011 - Added email and PDF logic  (LSJ)
#		: 10/15/2012 - Removed rentnet processes  (LSJ)
#		: 12/30/2015 - TT8641-32; logic for new CSV file  (LSJ)
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

usage: week2.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

if test -e /usr/upd/grp/INLGWRKMAS-W
then
	rm -f /usr/upd/grp/INLGWRKMAS-W
fi
if test -e /usr/upd/grp/SUSPWRKMAS-W
then
	rm -f /usr/upd/grp/SUSPWRKMAS-W
fi

${SHELL_DIR}/claim16.sh -c week -i sys > ${RPT_DIR}/week-claim16 2>&1
${SHELL_DIR}/claim16.sh -c week -i spo -s >> ${RPT_DIR}/week-claim16 2>&1
${SHELL_DIR}/claim16.sh -c week -i grp -s >> ${RPT_DIR}/week-claim16 2>&1

# Convert output files to PDF and email
echo "### week-claim16 ###" > ${RPT_DIR}/week-week2
cat ${RPT_DIR}/week-claim16 >> ${RPT_DIR}/week-week2

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/week-week2 | ps2pdf - ${RPT_DIR}/week-week2.pdf
enscript -Rgj --non-printable-format=space -o - ${MISC_DIR}/???CL16-SYS-INV-W | ps2pdf - ${RPT_DIR}/week-sys-totals.pdf
cp ${MISC_DIR}/???CL16-SYS-INVTOT-W ${RPT_DIR}/week-totals.csv

echo "Output from week2.sh process" | ${MAIL_PROG} -s "Week-cycle - week2" ${MAIL_TO} -a ${RPT_DIR}/week-week2.pdf -a ${RPT_DIR}/week-sys-totals.pdf -a ${RPT_DIR}/week-totals.csv 

exit 0
