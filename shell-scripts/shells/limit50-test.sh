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
MSG_FILE="/usr/lnk/tmp/LIMIT50-MESSAGE-TEST.csv"

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


${SHELL_DIR}/limit50.sh -t -i ${INPUT} > ${RPT_DIR}/limit50-test 2>&1
enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/limit50-test | ps2pdf - ${RPT_DIR}/limit50-test.pdf
echo "LIMIT50 test process.  Compare to information provided from Programmers." | ${MAIL_PROG} -a ${RPT_DIR}/limit50-test.pdf -a ${MSG_FILE} -s "LIMIT50 test" ${MAIL_TO}
rm -f ${RPT_DIR}/limit50-test
rm -f ${MSG_FILE}
	

exit 0
