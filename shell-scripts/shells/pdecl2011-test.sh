#!/bin/sh
#
# Program Name	: pdecl2011-test.sh
# Description	: pdecl2011 test run
# Author	: Linda S. Jefferis
# Date		: 01/28/2012
# Modifications : 11/24/2014 - replace wkohuth@pdmi.com with  drudawsky@pdmi.com (DME) (TT:8252-103)
#		: 11/24/2014 - add new error Reports as .csv files. (TT:8252-103) (DME)
#		: 03/27/2015 - add date to end of files. (TT:8252-109)(DME)
#		: 04/01/2015 - correct the resubmission attachment. Shoudl be in PDF format. (DME)
#		: 07/09/2015 - TT:12681-45 - Select-year flag logic
#		: 04/22/2016 - Remove ERR_FILE it has been removed from the pdecl2011.cob. (TT:14927-20; DME)
#               : 11/20/2018 - replace pvoytilla and drudawsky emails with  transteam@pdmi.com (TT:16553-110; DME)
#
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
PDE_DIR="/usr/lnk/wrk/pde"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
DATE=`date +%Y%m%d`
#
# Usage routine
usage()
{
	echo "USAGE:"
	echo "pdecl2011-test.sh year batch_range"
	echo "pdecl2011-test.sh -r year batch_range" 
	echo "-r	- resubmission"
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

echo ""
echo "Use select-year option? <y/n>"
read REPLY
case $REPLY in
   "y" | "Y") 
	RXYRFLG="-x"
	;;
   "n" | "N")
	RXYRFLG=""
	;;
    *)	echo "answer with y, Y, n, or N only"
	exit 1
	;;
esac


if [ "$1" = "-r" ]
then
	YEAR=$2
	BATCH_RANGE=$3
	PREFIX=`echo ${BATCH_RANGE} | cut -c9-12`R
	R_ERR_FILE="${PDE_DIR}/PDECL2011-ERRORS-${PREFIX}.csv"
	R_TEST="${RPT_DIR}/pdecl2011-rtest-${DATE}"
	${SHELL_DIR}/pdecl2011.sh -r -t -y ${YEAR} -b ${BATCH_RANGE} ${RXYRFLG} > ${R_TEST} 2>&1
	enscript -Rgj --non-printable-format=space -o - ${R_TEST} | ps2pdf - ${R_TEST}.pdf
	if test -s ${R_ERR_FILE}
	then
		echo "PDE test process. Error file is attached." | ${MAIL_PROG} -s "PDE resubmit test" ${MAIL_TO} -a ${R_TEST}.pdf -a ${R_ERR_FILE}
	else
		echo "PDE test process. No error file." | ${MAIL_PROG} -s "PDE resubmit test" ${MAIL_TO} -a ${R_TEST}.pdf 
	fi
#	rm -f ${R_TEST}*
	
else
	YEAR=$1
	BATCH_RANGE=$2
	PREFIX=`echo ${BATCH_RANGE} | cut -c9-12`
	S_ERR_FILE="${PDE_DIR}/PDECL2011-ERRORS-${PREFIX}S.csv"
	S_TEST="${RPT_DIR}/pdecl2011-test-${DATE}"
	${SHELL_DIR}/pdecl2011.sh -t -y ${YEAR} -b ${BATCH_RANGE} ${RXYRFLG} > ${S_TEST} 2>&1
	enscript -Rgj --non-printable-format=space -o - ${S_TEST} | ps2pdf - ${S_TEST}.pdf
	if test -s ${S_ERR_FILE}
        then
		echo "PDE test process. Error file attached." | ${MAIL_PROG} -a ${S_TEST}.pdf -a ${S_ERR_FILE} -s "PDE test run" ${MAIL_TO}
	else
		echo "PDE test process. No error file." | ${MAIL_PROG} -a ${S_TEST}.pdf -s "PDE test run" ${MAIL_TO}
	fi
#	rm -f ${S_TEST}* 
fi

scp ${PDE_DIR}/* robin:${PDE_DIR}
rm -f ${PDE_DIR}/*

exit 0
