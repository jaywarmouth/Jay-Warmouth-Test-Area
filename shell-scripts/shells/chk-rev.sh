#!/bin/sh
#
# Program Name	: chk-rev.sh
# Description	: Check Run  - claim45
#                 Runs: claim45
#                 -f Send Alternate CLAIM00MAS to shells
# Author	: Linda S. Jefferis
# Date		: 08/23/2013
#		: 11/11/2019 - Change "a2ps" ro "enscript"
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
PRT_DIR="/usr/lnk/po/misc"
FILE="null"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: chk-rev.sh [-f <filename>]

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
fi

# Convert output files to PDF and email
echo "### chk-claim45 ###" > ${RPT_DIR}/chk-rev
cat ${RPT_DIR}/chk-claim45 >> ${RPT_DIR}/chk-rev

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/chk-rev | ps2pdf - ${RPT_DIR}/chk-rev.pdf

echo "Output from chk-rev.sh process" | ${MAIL_PROG} -s "Check Run - chk-rev" ${MAIL_TO} -a ${RPT_DIR}/chk-rev.pdf 

exit 0
