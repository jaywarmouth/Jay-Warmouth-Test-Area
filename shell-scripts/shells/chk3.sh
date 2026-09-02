#!/bin/sh
#
# Program Name	: chk3.sh
# Description	: Check Run Report Processing
#                 Runs: claim07, claim97, and claim07tot
#                 Command line:
#                 -f Sends alternate CLAIM00MAS to shells
#			Default is /usr/lnk/tmp/CLWRK00MAS.chk
#		  -r Rerun option (to handle INLGWRK file)
# Author	: Linda S. Jefferis
# Date		: 09/18/2009
# Modifications : 10/11/2012 - Add claim127 process
#		: 11/11/2019 - Change "a2ps to "enscript"
#               : 07/21/2022 - enhancement changes
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
FILE="/usr/lnk/tmp/CLWRK00MAS.chk"
RERUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: chk3.sh [-f <filename>]

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
    -r) RERUN=1
	;;
  esac
  shift
done

if [ $RERUN = 0 ]
then
   	${SHELL_DIR}/claim07tot.sh -f ${FILE} > ${RPT_DIR}/chk-claim07tot 2>&1
fi
${SHELL_DIR}/claim127.sh -f ${FILE} > ${RPT_DIR}/chk-claim127 2>&1

# Convert output files to PDF and email
echo "### chk-claim07tot ###" > ${RPT_DIR}/chk-chk3
cat ${RPT_DIR}/chk-claim07tot >> ${RPT_DIR}/chk-chk3
echo "" >> ${RPT_DIR}/chk-chk3
echo "### chk-claim127 ###" >> ${RPT_DIR}/chk-chk3
cat ${RPT_DIR}/chk-claim127 >> ${RPT_DIR}/chk-chk3

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/chk-chk3 | ps2pdf - ${RPT_DIR}/chk-chk3.pdf

echo "Output from chk3.sh process" | ${MAIL_PROG} -s "Check Run - chk3" ${MAIL_TO} -a ${RPT_DIR}/chk-chk3.pdf 

exit 0
