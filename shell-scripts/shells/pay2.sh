#!/bin/sh
#
# Program Name	: pay2.sh
# Description	: Pay-Cycle Reporting Section
# Author	: Linda S. Jefferis
# Date		: 04/25/96
# Modifications : 11/30/1998 - Changed claim76 to claim92  (LSJ)
#		  01/25/1999 - Added claim109 to run  (LSJ)
#		  06/01/1999 - Removed claim72phin.sh run  (LSJ)
#		  03/20/2000 - Added claim117.sh (LSJ)
#		: 05/18/2000 - Removed runs of claim60, claim61  (LSJ)
#		: 09/06/2000 - Added claim113 to run  (LSJ)
#		: 02/13/2001 - Readded claim109 for SSI  (LSJ)
#		: 03/16/2001 - Removed claim109 from run  (LSJ)
#		: 04/03/2001 - Added claim119  (LSJ)
#		: 06/12/2001 - Added claim109 for HRMB  (LSJ)
#		: 06/12/2001 - Added claim94  (LSJ)
#		: 06/25/2001 - Removed claim113 (LSJ)
#		: 04/25/2002 - Added pay-rentnet.sh procedure  (LSJ)
#		: 06/26/2002 - Removed the print of *PRINT-CL16  (LSJ)
#		: 05/29/2003 - Added "pay-" to names of rpt files  (LSJ)
#		: 10/09/2003 - Removed claim92 from this process  (LSJ)
#		: 10/09/2003 - Removed most of the lp's of the rpt files  (LSJ)
#		: 11/20/2003 - Added the claim111su procedure  (LSJ)
#		: 12/19/2003 - Addition of claim123 procedure  (LSJ)
#		: 02/02/2004 - Addition of claim128 procedure  (LSJ)
#		: 06/21/2004 - Moved claims file procedures to pay-files.sh  (LSJ)
#		: 10/11/2004 - Added the claim44 procedure here  (LSJ)
#		: 03/14/2005 - Reordered runs  (LSJ)
#		: 04/24/2006 - Removed run of claim116  (LSJ)
#		: 12/18/2006 - Removed claim128  (LSJ)
#		: 08/19/2008 - Removed 'claim44.sh -j pay' process  (LSJ)
#		: 09/18/2009 - Changes for switch to new check run  (LSJ)
#		: 04/28/2011 - Added email and PDF logic
#		: 04/16/2012 - Removed claim09 process
#		: 02/02/2015 - Due to term of sys0052 and sys0071, remove rented network related procedures. (TT #12718-2, #12713-2).
#               : 12/30/2015 - TT8641-32; logic for new CSV file  (LSJ)
#		: 05/29/2019 - TT13915-84; remove claim123 logic
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

usage: pay2.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

if test -e /usr/upd/grp/INLGWRKMAS-P
then
        rm -f /usr/upd/grp/INLGWRKMAS-P
fi
if test -e /usr/upd/grp/SUSPWRKMAS-P
then
        rm -f /usr/upd/grp/SUSPWRKMAS-P
fi

${SHELL_DIR}/claim16.sh -c pay -i sys > ${RPT_DIR}/pay-claim16 2>&1
${SHELL_DIR}/claim16.sh -c pay -i spo -s >> ${RPT_DIR}/pay-claim16 2>&1
${SHELL_DIR}/claim16.sh -c pay -i grp -s >> ${RPT_DIR}/pay-claim16 2>&1

# Convert output files to PDF and email
echo "### pay-claim16 ###" > ${RPT_DIR}/pay-pay2
cat ${RPT_DIR}/pay-claim16 >> ${RPT_DIR}/pay-pay2

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/pay-pay2 | ps2pdf - ${RPT_DIR}/pay-pay2.pdf
enscript -Rgj --non-printable-format=space -o - ${MISC_DIR}/???CL16-SYS-INV-P | ps2pdf - ${RPT_DIR}/pay-sys-totals.pdf
cp ${MISC_DIR}/???CL16-SYS-INVTOT-P ${RPT_DIR}/pay-totals.csv

echo "Output from pay2.sh process" | ${MAIL_PROG} -s "pay-cycle - pay2" ${MAIL_TO} -a ${RPT_DIR}/pay-pay2.pdf -a ${RPT_DIR}/pay-sys-totals.pdf -a ${RPT_DIR}/pay-totals.csv 

exit 0
