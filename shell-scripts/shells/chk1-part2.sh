#!/bin/sh
#
# Program Name	: chk1-part2.sh
# Description	: Check Run secondary update process 
#                 Runs: claim58, claim07(neg)
#                 -f <filename> Send Alternate CLAIM00MAS to shells
# Author	: Linda S. Jefferis
# Date		: 09/18/2009
# Modifications : 11/25/2009 - Changed logic for CL58-C report to convert to pdf instead of printing.  (LSJ)
#		: 08/01/2012 - added "--print-anyway=1 --non-printable-format=blank " logic to a2ps commpnad for CL58 report.
#		: 09/16/2014 - added MAIL_ET for discrepancy report  (LSJ)
#		: 01/16/2015 - Change the MAIL_ET variable to pharmacy@pdmi.com,835@pdmi.com. (TT:13915-22; DME)
#		: 11/11/2019 - Change "a2ps" to "enscript"
#		: 07/21/2022 - enhancement changes
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
PRT_DIR="/usr/lnk/misc"
OUT_DIR="/usr/lnk/wt/pdm/chkrun"
FILE="/usr/lnk/tmp/CLWRK00MAS.chk"
MAIL_TO="operations@pdmi.com"
MAIL_ET="pharmacy@pdmi.com,835@pdmi.com"
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: chk1-part2.sh [-f <filename>] 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

# Check command line validity
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE=$1
        ;;
  esac
  shift
done

if [ ${FILE} = "null" ]
then
   usage
else
   ${SHELL_DIR}/claim58.sh -f ${FILE} > ${RPT_DIR}/chk-claim58 2>&1
   if test -s ${PRT_DIR}/????CL58-C
   then
	enscript -rgj -f Courier9 --non-printable-format=space -o - ${PRT_DIR}/????CL58-C | ps2pdf - ${OUT_DIR}/CL58-C.pdf
	${MAIL_PROG} -s "INDEPENDENT CODE/CHAIN CODE DISCREPANCY REPORT" -c ${MAIL_TO} ${MAIL_ET} -a ${OUT_DIR}/CL58-C.pdf
   fi
   ${SHELL_DIR}/claim07.sh -n -f ${FILE} > ${RPT_DIR}/chk-claim07neg 2>&1
fi

# Convert output files to PDF and email
echo "### chk-claim58 ###" > ${RPT_DIR}/chk-chk1-part2
cat ${RPT_DIR}/chk-claim58 >> ${RPT_DIR}/chk-chk1-part2
echo "" >> ${RPT_DIR}/chk-chk1-part2
echo "### chk-claim07neg ###" >> ${RPT_DIR}/chk-chk1-part2
cat ${RPT_DIR}/chk-claim07neg >> ${RPT_DIR}/chk-chk1-part2

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/chk-chk1-part2 | ps2pdf - ${RPT_DIR}/chk-chk1-part2.pdf

echo "Output from chk1-part2.sh process" | ${MAIL_PROG} -s "Check Run - chk1-part2" ${MAIL_TO} -a ${RPT_DIR}/chk-chk1-part2.pdf 

exit 0
