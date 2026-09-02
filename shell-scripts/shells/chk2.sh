#!/bin/sh
#
# Program Name	: chk2.sh
# Description	: Check Run Report Processing
#                 Runs: claim20
#                 Command line:
#                 -f Sends alternate CLAIM00MAS to shells
# Author	: Linda S. Jefferis
# Date		: 09/18/2009
# Modifications : 01/23/2012 - Added PDF and email logic
#		: 10/20/2014 - reorganizing for check outsourcing; moved claim97 process here from chk3.sh and removed claim37 process (TT #6939-2)
#		: 01/01/2018 - TT:13915-59
#		: 02/09/2018 - Add logic for copy of CL20 report for easier searching.
#               : 07/21/2022 - enhancement changes
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE="/usr/lnk/tmp/CLWRK00MAS.chk"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: chk2.sh [-f <filename>]

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
   ${SHELL_DIR}/claim20.sh -f ${FILE} > ${RPT_DIR}/chk-claim20 2>&1
fi

# Convert output files to PDF and email
echo "### chk-claim20 ###" > ${RPT_DIR}/chk-chk2
cat ${RPT_DIR}/chk-claim20 >> ${RPT_DIR}/chk-chk2

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/chk-chk2 | ps2pdf - ${RPT_DIR}/chk-chk2.pdf
cp /usr/lnk/po/???CL20Z-C.L1 /usr/lnk/wt/pdm/chkrun/chkrun-CL20.txt

echo "Output from chk2.sh process" | ${MAIL_PROG} -s "Check Run - chk2" ${MAIL_TO} -a ${RPT_DIR}/chk-chk2.pdf 

exit 0
