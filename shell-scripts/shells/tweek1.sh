#!/bin/sh
#
# Program Name	: tweek.sh
# Description	: Tweek-Cycle Update Section
# Author	: Linda S. Jefferis
# Date		: 09/16/2010
# Modifications : 10/01/2011 - Added email and PDF logic
#		: 01/21/2015 - Added YEAR variable and logic (LSJ)
#		: 09/27/2016 - Updated YEAR variable from "last year" to "2 years ago"  (LSJ)
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

usage: tweek1.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/pdbat01.sh -c tweek > ${RPT_DIR}/tweek-pdbat01 2>&1
${SHELL_DIR}/rever03.sh -c tweek -d ${YEAR}0101 > ${RPT_DIR}/tweek-rever03 2>&1
${SHELL_DIR}/claim68.sh -c tweek > ${RPT_DIR}/tweek-claim68 2>&1
${SHELL_DIR}/claim46.sh -c tweek -d ${YEAR}0101 > ${RPT_DIR}/tweek-claim46 2>&1
${SHELL_DIR}/claim47.sh -c tweek -d ${YEAR4}0101 > ${RPT_DIR}/tweek-claim47 2>&1

# Convert output files to PDF and email
echo "### tweek-pdbat01 ###" > ${RPT_DIR}/tweek-tweek1
cat ${RPT_DIR}/tweek-pdbat01 >> ${RPT_DIR}/tweek-tweek1
echo "" >> ${RPT_DIR}/tweek-tweek1
echo "### tweek-rever03 ###" >> ${RPT_DIR}/tweek-tweek1
cat ${RPT_DIR}/tweek-rever03 >> ${RPT_DIR}/tweek-tweek1
echo "" >> ${RPT_DIR}/tweek-tweek1
echo "### tweek-claim68 ###" >> ${RPT_DIR}/tweek-tweek1
cat ${RPT_DIR}/tweek-claim68 >> ${RPT_DIR}/tweek-tweek1
echo "" >> ${RPT_DIR}/tweek-tweek1
echo "### tweek-claim46 ###" >> ${RPT_DIR}/tweek-tweek1
cat ${RPT_DIR}/tweek-claim46 >> ${RPT_DIR}/tweek-tweek1
echo "" >> ${RPT_DIR}/tweek-tweek1
echo "### tweek-claim47 ###" >> ${RPT_DIR}/tweek-tweek1
cat ${RPT_DIR}/tweek-claim47 >> ${RPT_DIR}/tweek-tweek1

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/tweek-tweek1 | ps2pdf - ${RPT_DIR}/tweek-tweek1.pdf

if test -s ${PRT_DIR}/???CL68-X
then
        enscript -rgj -f Courier9 --non-printable-format=space -o - ${PRT_DIR}/???CL68-X | ps2pdf - ${PRT_DIR}/tweek-Invalid_Claims_Report.pdf
        echo "Output from tweek1.sh process.  The attached Invalid Claims Report also needs reviewed." | ${MAIL_PROG} -s "TWeek-cycle - tweek1" ${MAIL_TO} -a ${RPT_DIR}/tweek-tweek1.pdf -a ${PRT_DIR}/tweek-Invalid_Claims_Report.pdf 
else
        echo "Output from tweek1.sh process" | ${MAIL_PROG} -s "TWeek-cycle - tweek1" ${MAIL_TO} -a ${RPT_DIR}/tweek-tweek1.pdf 
fi

${SHELL_DIR}/tweek2.sh > ${RPT_DIR}/tweek-prod10-claim16 2>&1

exit 0
