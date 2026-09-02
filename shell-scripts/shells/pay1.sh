#!/bin/sh
#
# Program Name	: pay1.sh
# Description	: Pay-Cycle Update Section
# Author	: Linda S. Jefferis
# Date		: 04/25/96
# Modifications : 04/02/99 - Changed claim72 run to claim109  (LSJ)
#		  05/28/99 - Added century to input dates for claim46 and claim47  (LSJ)
#		: 07/19/00 - Removed claim109(week) run  (LSJ)
#		: 11/24/00 - Changed date on claim46 and claim47  (LSJ)
#		: 05/29/03 - Added "pay-" to names of rpt files  (LSJ)
#		: 12/26/03 - Removed most of the printing of the rpt files (LSJ)
#		: 01/29/04 - Addition of two separate runs of claim70.sh  (LSJ)
#		: 01/14/2005 - Added pdbat01 and rever03 to this script  (LSJ)
#		: 06/15/2005 - Moved claim120 procedure to pay3.sh  (LSJ)
#		: 06/14/2006 - Changed input dates from 20040101 to 20050601
#		: 03/27/2008 - Added claim58.sh process  (LSJ)
#		: 10/07/2008 - Changed 20050101 date to 20070101  (LSJ)
#		: 01/12/2009 - Changed input dates from 20070101 to 20080101  (LSJ)
#		: 01/12/2009 - Commented out claim70 processes  (LSJ)
#		: 08/22/2009 - Updates for switch to new check run  (LSJ)
#		: 04/28/2011 - Added claim16 and email of PDF files
#               : 01/21/2015 - Added YEAR variable and logic (LSJ)
#               : 09/27/2016 - Updated YEAR variable from "last year" to "2 years ago"  (LSJ)
#               : 04/11/2018 - Added email of CSV totals
#		: 11/12/2019 - Change "a2ps" to "enscript"
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
PRT_DIR="/usr/lnk/misc"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
YEAR=`date -d "2 years ago" +%Y`
YEAR4=`date -d "4 years ago" +%Y`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pay1.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/pdbat01.sh -c pay > ${RPT_DIR}/pay-pdbat01 2>&1
${SHELL_DIR}/rever03.sh -c pay -d ${YEAR}0101 > ${RPT_DIR}/pay-rever03 2>&1
${SHELL_DIR}/claim68.sh -c pay > ${RPT_DIR}/pay-claim68 2>&1
${SHELL_DIR}/claim46.sh -c pay -d ${YEAR}0101 > ${RPT_DIR}/pay-claim46 2>&1
${SHELL_DIR}/claim47.sh -c pay -d ${YEAR4}0101 > ${RPT_DIR}/pay-claim47 2>&1

# Convert output files to PDF and email
echo "### pay-pdbat01 ###" > ${RPT_DIR}/pay-pay1
cat ${RPT_DIR}/pay-pdbat01 >> ${RPT_DIR}/pay-pay1
echo "" >> ${RPT_DIR}/pay-pay1
echo "### pay-rever03 ###" >> ${RPT_DIR}/pay-pay1
cat ${RPT_DIR}/pay-rever03 >> ${RPT_DIR}/pay-pay1
echo "" >> ${RPT_DIR}/pay-pay1
echo "### pay-claim68 ###" >> ${RPT_DIR}/pay-pay1
cat ${RPT_DIR}/pay-claim68 >> ${RPT_DIR}/pay-pay1
echo "" >> ${RPT_DIR}/pay-pay1
echo "### pay-claim46 ###" >> ${RPT_DIR}/pay-pay1
cat ${RPT_DIR}/pay-claim46 >> ${RPT_DIR}/pay-pay1
echo "" >> ${RPT_DIR}/pay-pay1
echo "### pay-claim47 ###" >> ${RPT_DIR}/pay-pay1
cat ${RPT_DIR}/pay-claim47 >> ${RPT_DIR}/pay-pay1

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/pay-pay1 | ps2pdf - ${RPT_DIR}/pay-pay1.pdf

if test -s ${PRT_DIR}/???CL68-P
then
        enscript -rgj -f Courier9 --non-printable-format=space -o - ${PRT_DIR}/???CL68-P | ps2pdf - ${PRT_DIR}/pay-Invalid_Claims_Report.pdf
        echo "Output from pay1.sh process.  The attached Invalid Claims Report also needs reviewed." | ${MAIL_PROG} -s "Pay-cycle - pay1" ${MAIL_TO} -a ${RPT_DIR}/pay-pay1.pdf -a ${PRT_DIR}/pay-Invalid_Claims_Report.pdf 
else
        echo "Output from pay1.sh process" | ${MAIL_PROG} -s "Pay-cycle - pay1" ${MAIL_TO} -a ${RPT_DIR}/pay-pay1.pdf 
fi

${SHELL_DIR}/pay2.sh > ${RPT_DIR}/pay-prod10-claim16 2>&1

exit 0
