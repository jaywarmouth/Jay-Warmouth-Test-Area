#!/bin/sh
#
# Program Name	: chk1-part3.sh
# Description	: Check Run part 3 update
#                 Runs: claim07, claim37 for balancing
#                 -f <filename> Send Alternate CLAIM00MAS to shells
# Author	: Linda S. Jefferis
# Date		: 09/18/2009
# Modifications : 11/11/2019 - Change "a2ps" to "enscript"
#		: 07/21/2022 - enhancement changes
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
PRT_DIR="/usr/lnk/misc"
FILE="/usr/lnk/tmp/CLWRK00MAS.chk"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: chk1-part3.sh [-f <filename>]

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
   ${SHELL_DIR}/claim07.sh -f ${FILE} > ${RPT_DIR}/chk-claim07 2>&1
   ${SHELL_DIR}/claim37.sh -f ${FILE} > ${RPT_DIR}/chk-claim37 2>&1
fi

# Convert output files to PDF and email
echo "### chk-claim07 ###" > ${RPT_DIR}/chk-chk1-part3
cat ${RPT_DIR}/chk-claim07 >> ${RPT_DIR}/chk-chk1-part3
echo "" >> ${RPT_DIR}/chk-chk1-part3
echo "### chk-claim37 ###" >> ${RPT_DIR}/chk-chk1-part3
cat ${RPT_DIR}/chk-claim37 >> ${RPT_DIR}/chk-chk1-part3

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/chk-chk1-part3 | ps2pdf - ${RPT_DIR}/chk-chk1-part3.pdf
enscript -rgj -a2- -f Courier9 --non-printable-format=space -o - ${PRT_DIR}/CL07-C-TOTALS | ps2pdf - ${PRT_DIR}/CL07-C-TOTALS.pdf
enscript -Rgj -a2- --non-printable-format=space -o - ${PRT_DIR}/CL37-C-TOTALS | ps2pdf - ${PRT_DIR}/CL37-C-TOTALS.pdf

echo "Output from chk1-part3.sh process" | ${MAIL_PROG}  -s "Check Run - chk1-part3" ${MAIL_TO} -a ${RPT_DIR}/chk-chk1-part3.pdf -a ${PRT_DIR}/CL07-C-TOTALS.pdf -a ${PRT_DIR}/CL37-C-TOTALS.pdf 

exit 0
