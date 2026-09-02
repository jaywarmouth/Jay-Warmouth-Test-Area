#!/bin/sh
#
# Program Name	: limit50-test.sh
# Description	: limit50 test run
#		  Command Line:
#		  -i <LIMIT50 input file>
# Author	: Linda S. Jefferis
# Date		: 01/12/2012
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
INPUT="null"
DATE=`date +%Y%m%d`
MSG_FILE="/usr/lnk/tmp/LIMIT50-MESSAGE-${DATE}.csv"

#
# Usage routine
usage()
{
	echo "USAGE:"
	echo "limit50-test.sh -i <LIMIT50 input file>"
	exit 1
}

#
# Main routine
#

# Check command line validity
if [ $# -lt 2 ]
then
	usage
fi
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INPUT=$1
        ;;
  esac
  shift
done


${SHELL_DIR}/limit50.sh -i ${INPUT} > ${RPT_DIR}/limit50-update 2>&1
cp ${RPT_DIR}/limit50-update ${RPT_DIR}/limit50-update-${DATE}
enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/limit50-update-${DATE} | ps2pdf - ${RPT_DIR}/limit50-update-${DATE}.pdf
echo "LIMIT50 update process." | ${MAIL_PROG} -a ${RPT_DIR}/limit50-update-${DATE}.pdf -a ${MSG_FILE} -s "LIMIT50 update" ${MAIL_TO}
rm -f ${RPT_DIR}/limit50-update-${DATE}
rm -f ${MSG_FILE}
	

exit 0
