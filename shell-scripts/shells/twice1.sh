#!/bin/sh
#
# Program Name	: twice.sh
# Description	: Twice-Cycle Update Section
# Author	: Linda S. Jefferis
# Date		: 12/09/2004
# Modifications : 12/30/2004 - Added rever03 to this script  (LSJ)
#		: 01/14/2004 - Added pdbat01 to this script  (LSJ)
#		: 01/30/2006 - Temporarily changed input date for claim46 and claim47 from 20040101 to 20031001  (LSJ)
#		: 02/07/2006 - Put input dates back to 20040101  (LSJ)
#		: 06/14/2006 - Changed input dates to 20050601  (LSJ)
#		: 03/02/2007 - Changed input dates to 20051101 from 20060101  (LSJ)
#		: 04/09/2007 - Changed input dates to 20050701 from 20051101  (LSJ)
#		: 03/27/2008 - Added claim58 process  (LSJ) 
#		: 10/07/2008 - Changed 20051001 to 20070101  (LSJ)
#		: 08/22/2009 - Updates for switch to new check run  (LSJ)
#		: 12/08/2011 - Added claim16 and PDF logic
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

usage: twice1.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/pdbat01.sh -c twice > ${RPT_DIR}/twice-pdbat01 2>&1
${SHELL_DIR}/rever03.sh -c twice -d ${YEAR}0101 > ${RPT_DIR}/twice-rever03 2>&1
${SHELL_DIR}/claim68.sh -c twice > ${RPT_DIR}/twice-claim68 2>&1
${SHELL_DIR}/claim46.sh -c twice -d ${YEAR}0101 > ${RPT_DIR}/twice-claim46 2>&1
${SHELL_DIR}/claim47.sh -c twice -d ${YEAR4}0101 > ${RPT_DIR}/twice-claim47 2>&1

# Convert output files to PDF and email
echo "### twice-pdbat01 ###" > ${RPT_DIR}/twice-twice1
cat ${RPT_DIR}/twice-pdbat01 >> ${RPT_DIR}/twice-twice1
echo "" >> ${RPT_DIR}/twice-twice1
echo "### twice-rever03 ###" >> ${RPT_DIR}/twice-twice1
cat ${RPT_DIR}/twice-rever03 >> ${RPT_DIR}/twice-twice1
echo "" >> ${RPT_DIR}/twice-twice1
echo "### twice-claim68 ###" >> ${RPT_DIR}/twice-twice1
cat ${RPT_DIR}/twice-claim68 >> ${RPT_DIR}/twice-twice1
echo "" >> ${RPT_DIR}/twice-twice1
echo "### twice-claim46 ###" >> ${RPT_DIR}/twice-twice1
cat ${RPT_DIR}/twice-claim46 >> ${RPT_DIR}/twice-twice1
echo "" >> ${RPT_DIR}/twice-twice1
echo "### twice-claim47 ###" >> ${RPT_DIR}/twice-twice1
cat ${RPT_DIR}/twice-claim47 >> ${RPT_DIR}/twice-twice1

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/twice-twice1 | ps2pdf - ${RPT_DIR}/twice-twice1.pdf

if test -s ${PRT_DIR}/???CL68-T
then
        enscript -rgj -f Courier9 --non-printable-format=space -o - ${PRT_DIR}/???CL68-T | ps2pdf - ${PRT_DIR}/twice-Invalid_Claims_Report.pdf
        echo "Output from twice1.sh process.  The attached Invalid Claims Report also needs reviewed." | ${MAIL_PROG} -s "Twice-cycle - twice1" ${MAIL_TO} -a ${RPT_DIR}/twice-twice1.pdf -a ${PRT_DIR}/twice-Invalid_Claims_Report.pdf 
else
        echo "Output from twice1.sh process" | ${MAIL_PROG} -s "twice-cycle - twice1" ${MAIL_TO} -a ${RPT_DIR}/twice-twice1.pdf 
fi

${SHELL_DIR}/twice2.sh > ${RPT_DIR}/twice-prod10-claim16 2>&1

exit 0
