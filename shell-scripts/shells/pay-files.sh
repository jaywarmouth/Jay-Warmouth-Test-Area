#!/bin/sh
#
# Program Name	: pay-files.sh
# Description	: Pay-Cycle Reporting Section
# Author	: Linda S. Jefferis
# Date		: 06/21/2004
# Modifications : 08/12/2004 - Addition of claim130.sh procedure  (LSJ)
#		: 07/1902005 - Removed claim119 procedure  (LSJ)
#		: 01/17/2006 - Removed lp of the rpt files  (LSJ)
#		: 02/14/2006 - Removed claim94  (LSJ)
#		: 02/09/2007 - Removed claim106, per Allan's request  (LSJ)
#		: 08/13/2007 - Removed claim124; sys0067 is termed  (LSJ)
#		: 12/31/2007 - Added claim111rx and added -c pay to claim117  (LSJ)
#		: 01/14/2008 - Added claim109eb  (LSJ)
#		: 11/10/2008 - Added claim132  (LSJ)
#		: 03/19/2009 - Added claim133  (LSJ)
#		: 01/27/2010 - Add clmrt01  (LSJ)
#		: 08/31/2010 - Added clncpsp01  (LSJ)
#		: 02/02/2011 - Added claim109gran  (LSJ)
#		: 04/28/2011 - Added email and PDF logic
#		: 06/30/2011 - Added claim109do  (LSJ)
#		: 07/12/2013 - Added back claim109gran process for North Cypress file  (LSJ0
#		: 01/10/2012 - Changed claim111 to claim111d0 and removed claim109
#		: 10/15/2012 - Removed clmrt01 process
#		: 01/08/2013 - Removed clncpdp01
#		: 01/28/2013 - Removed claim109gran (DME)
#		: 07/16/2013 - Re-added claim109fran and clmrt01 processes
#		: 06/27/2014 - Add "-v" option to always create version 5010 formatted files instead of using entry in OUTDEM
#		: 01/20/2015 - Remove claim117 process (TT #12717-2)
#		: 05/11/2016 - TT15163-5; add claim109hcrm process
#		: 08/08/2017 - TT13915-53; remove claim109eb and claim132 procedures.
#		: 07/17/2018 - removal of claim109hcrm process
#               : 09/21/2018 - Removal of claim109d0 
#		: 11/12/2019 - Change "a2ps" to "enscript"

# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pay-files.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim111rx.sh -c pay > ${RPT_DIR}/pay-claim111rx 2>&1
${SHELL_DIR}/claim111d0.sh -c pay > ${RPT_DIR}/pay-claim111d0 2>&1
${SHELL_DIR}/claim130.sh -c pay > ${RPT_DIR}/pay-claim130 2>&1

# Convert output files to PDF and email
echo "### pay-claim111rx ###" >> ${RPT_DIR}/pay-pay-files
cat ${RPT_DIR}/pay-claim111rx >> ${RPT_DIR}/pay-pay-files
echo "### pay-claim111d0 ###" >> ${RPT_DIR}/pay-pay-files
cat ${RPT_DIR}/pay-claim111d0 >> ${RPT_DIR}/pay-pay-files
echo "### pay-claim130 ###" >> ${RPT_DIR}/pay-pay-files
cat ${RPT_DIR}/pay-claim130 >> ${RPT_DIR}/pay-pay-files


enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/pay-pay-files | ps2pdf - ${RPT_DIR}/pay-pay-files.pdf

echo "Output from pay-files.sh process" | ${MAIL_PROG} -s "pay-cycle - pay-files" ${MAIL_TO} -a ${RPT_DIR}/pay-pay-files.pdf 

exit 0
