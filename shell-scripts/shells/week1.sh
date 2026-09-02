#!/bin/sh
#
# Program Name	: week1.sh
# Description	: Week-Cycle Update and Report
# Author	: Linda S. Jefferis
# Date		: 04/26/96
# Modifications : 06/20/97 - LSJ - Added cp for MMRX file & DATE2 variable
#		: 04/01/99 - LSJ - Removed SIHO logic
#		: 04/01/99 - LSJ - changed claim72 to claim109
#		: 05/11/01 - LSJ - Updated to use for Aultman week-cycle
#		: 04/19/04 - LSJ - Removed lp of rpt files
#		: 05/31/2005 - Totally new script for payment week cycle  (LSJ)
#		: 04/01/2008 - Added claim58.sh process
#		: 10/07/2008 - changed dates from 20060101 to 20070101  (LSJ)
#		: 01/12/2009 - changed input dates from 20070101 to 20080101
#		: 01/12/2009 - removed claim70  (LSJ)
#		: 08/22/2009 - Updates for switch to new check run  (LSJ)
#		: 03/28/2011 - Added email and PDF logic  (LSJ)
#               : 01/21/2015 - Added YEAR variable and logic (LSJ)
#               : 09/27/2016 - Updated YEAR variable from "last year" to "2 years ago"  (LSJ)
#		: 04/11/2018 - Added email of CSV totals
#		: 11/12/2019 - Change "a2ps" to "enscript"
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
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

usage: week1.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/pdbat01.sh -c week > ${RPT_DIR}/week-pdbat01 2>&1
${SHELL_DIR}/rever03.sh -c week -d ${YEAR}0101 > ${RPT_DIR}/week-rever03 2>&1
${SHELL_DIR}/claim68.sh -c week > ${RPT_DIR}/week-claim68 2>&1
${SHELL_DIR}/claim46.sh -c week -d ${YEAR}0101 > ${RPT_DIR}/week-claim46 2>&1
${SHELL_DIR}/claim47.sh -c week -d ${YEAR4}0101 > ${RPT_DIR}/week-claim47 2>&1

# Convert output files to PDF and email
echo "### week-pdbat01 ###" > ${RPT_DIR}/week-week1
cat ${RPT_DIR}/week-pdbat01 >> ${RPT_DIR}/week-week1
echo "" >> ${RPT_DIR}/week-week1
echo "### week-rever03 ###" >> ${RPT_DIR}/week-week1
cat ${RPT_DIR}/week-rever03 >> ${RPT_DIR}/week-week1
echo "" >> ${RPT_DIR}/week-week1
echo "### week-claim68 ###" >> ${RPT_DIR}/week-week1
cat ${RPT_DIR}/week-claim68 >> ${RPT_DIR}/week-week1
echo "" >> ${RPT_DIR}/week-week1
echo "### week-claim46 ###" >> ${RPT_DIR}/week-week1
cat ${RPT_DIR}/week-claim46 >> ${RPT_DIR}/week-week1
echo "" >> ${RPT_DIR}/week-week1
echo "### week-claim47 ###" >> ${RPT_DIR}/week-week1
cat ${RPT_DIR}/week-claim47 >> ${RPT_DIR}/week-week1

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/week-week1 | ps2pdf - ${RPT_DIR}/week-week1.pdf

if test -s ${PRT_DIR}/???CL68-W
then
	enscript -rgj -f Courier9 --non-printable-format=space -o - ${PRT_DIR}/???CL68-W | ps2pdf - ${PRT_DIR}/week-Invalid_Claims_Report.pdf
	echo "Output from week1.sh process.  The attached Invalid Claims Report also needs reviewed." | ${MAIL_PROG} -s "Week-cycle - week1" ${MAIL_TO} -a ${RPT_DIR}/week-week1.pdf -a ${PRT_DIR}/week-Invalid_Claims_Report.pdf 
else
	echo "Output from week1.sh process" | ${MAIL_PROG} -s "Week-cycle - week1" ${MAIL_TO} -a ${RPT_DIR}/week-week1.pdf 
fi

${SHELL_DIR}/week2.sh > ${RPT_DIR}/week-prod10-claim16 2>&1

exit 0
