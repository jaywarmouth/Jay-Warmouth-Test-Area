#!/bin/sh
#
# Program Name	: chk1.sh
# Description	: Check Run Update Section
#                 Runs: claim45, claim88
#                 -f Send Alternate CLAIM00MAS to shells
# Author	: Linda S. Jefferis
# Date		: 09/18/2009
# Modifications : 5/4/2011 - Added PDF and email logic
#		: 07/31/2013 - Removed claim45 process
#		: TT13915-64 - removal of claim70 processes
#		: 11/110/2019 - Change "a2ps" ro "enscript"
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

usage: chk1.sh [-f <filename>]

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
   ${SHELL_DIR}/claim45.sh -f ${FILE} > ${RPT_DIR}/chk-claim45 2>&1
   ${SHELL_DIR}/claim88.sh -f ${FILE} > ${RPT_DIR}/chk-claim88 2>&1

fi

# Convert output files to PDF and email
echo "### chk-claim45 ###" > ${RPT_DIR}/chk-chk1
cat ${RPT_DIR}/chk-claim45 >> ${RPT_DIR}/chk-chk1
echo "" >> ${RPT_DIR}/chk-chk1
echo "### chk-claim88 ###" >> ${RPT_DIR}/chk-chk1
cat ${RPT_DIR}/chk-claim88 >> ${RPT_DIR}/chk-chk1

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/chk-chk1 | ps2pdf - ${RPT_DIR}/chk-chk1.pdf

echo "Output from chk1.sh process" | ${MAIL_PROG} -s "Check Run - chk1" ${MAIL_TO} -a ${RPT_DIR}/chk-chk1.pdf 

exit 0
