#!/bin/ksh
#
# Program Name	: pdecl07-test.sh
# Description	: pdecl07 test run
#		  Command Line:
#		  -f <input file>
# Author	: Linda S. Jefferis
# Date		: 01/09/2013
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
INPUT="null"
OUT_FILE="/usr/lnk/tmp/PDECL07-REPORT-TEST.csv"

#
# Usage routine
usage()
{
	echo "USAGE:"
	echo "pdecl07-test.sh -f <input file>"
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
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INPUT=$1
        ;;
  esac
  shift
done


${SHELL_DIR}/pdecl07.sh -t -f ${INPUT} > ${RPT_DIR}/pdecl07-test 2>&1
a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/pdecl07-test | ps2pdf - ${RPT_DIR}/pdecl07-test.pdf
echo "PDECL07 test process.  Compare to information provided from Programmers." | ${MAIL_PROG} -a ${RPT_DIR}/pdecl07-test.pdf -a ${OUT_FILE} -s "PDECL07 test" ${MAIL_TO}
rm -f ${RPT_DIR}/pdecl07-test
rm -f ${OUT_FILE}
	

exit 0
