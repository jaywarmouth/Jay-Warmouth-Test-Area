#!/bin/ksh
#
# Program Name	: pdecl07-update.sh
# Description	: pdecl07 update run
#		  Command Line:
#		  -f <REJECTC00DES input file>
# Author	: Linda S. Jefferis
# Date		: 01/09/2013
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
INPUT="null"
DATE=`date +%Y%m%d`
OUT_FILE="/usr/lnk/tmp/PDECL07-REPORT-${DATE}.csv"
YEAR=`date +%Y`
ARCH_DIR="/usr/lnk/pde/arch/${YEAR}"

#
# Usage routine
usage()
{
	echo "USAGE:"
	echo "pdecl07-update.sh -f <PDECL07 input file>"
	exit 1
}

#
# Archive and Cleanup
cleanup()
{
	mv ${OUT_FILE} ${ARCH_DIR}
	mv ${RPT_DIR}/pdecl07-update-${DATE} ${ARCH_DIR}	
	rm -f ${RPT_DIR}/pdecl07-update-${DATE}.pdf
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


${SHELL_DIR}/pdecl07.sh -f ${INPUT} > ${RPT_DIR}/pdecl07-update 2>&1
cp ${RPT_DIR}/pdecl07-update ${RPT_DIR}/pdecl07-update-${DATE}
a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/pdecl07-update-${DATE} | ps2pdf - ${RPT_DIR}/pdecl07-update-${DATE}.pdf
echo "PDECL07 update process." | ${MAIL_PROG} -a ${RPT_DIR}/pdecl07-update-${DATE}.pdf -a ${OUT_FILE} -s "PDECL07 update" ${MAIL_TO}

cleanup
	

exit 0
