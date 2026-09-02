#!/bin/ksh
#
# Program Name	: pdecl2011-update.sh
# Description	: pdecl2011 update run
# Author	: Linda S. Jefferis
# Date		: 01/28/2012
# Modifications : 11/24/2014 - add pvoytilla@pdmi.com and drudawsky@pdmi.com (DME) (TT:8252-103)
#               : 11/24/2014 - add new error Reports R_ERR_FILE and S_ERR_FILE files. (TT:8252-103) (DME)
#		: 03/27/2015 - ADD date to end of all reports. (TT:8252-109)(DME)
#		: 04/02/2015 - Remove date from Error file variables. These do not pass to the COBOL program. (DME)
#               : 07/09/2015 - TT:12681-45 - Select-year flag logic
#               : 04/22/2016 - Remove ERR_FILE it has been removed from the pdecl2011.cob. (TT:14927-20; DME)
#               : 11/20/2018 - replace pvoytilla and drudawsky emails with  transteam@pdmi.com (TT:16553-110; DME)
#
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
PDE_DIR="/usr/lnk/misc"
RPT_DIR="/usr/lnk/rpt"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
DATE=`date +%Y%m%d%H%M%S`

#
# Usage routine
usage()
{
	echo "USAGE:"
	echo "pdecl2011-update.sh year batch_range"
	echo "pdecl2011-update.sh -r year batch_range"
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
    *)  echo "answer with y, Y, n, or N only"
        exit 1
        ;;
esac


if [ "$1" = "-r" ]
then
	YEAR=$2
	BATCH_RANGE=$3
	PREFIX=`echo ${BATCH_RANGE} | cut -c9-12`R
	R_ERR_FILE="${PDE_DIR}/PDECL2011-ERRORS-${PREFIX}.csv"
	${SHELL_DIR}/pdecl2011.sh -r -y ${YEAR} -b ${BATCH_RANGE} ${RXYRFLG} > ${RPT_DIR}/pdecl2011-R-${DATE} 2>&1
	enscript -Rgj --non-printable-format=space  -o - ${RPT_DIR}/pdecl2011-R-${DATE} | ps2pdf - ${RPT_DIR}/pdecl2011-R-${DATE}.pdf
	if test -s ${R_ERR_FILE}
        then
		echo "PDE resubmission update process.  Error file attached." | ${MAIL_PROG} -s "PDE Resubmission Update Process" ${MAIL_TO} -a ${RPT_DIR}/pdecl2011-R-${DATE}.pdf -a ${R_ERR_FILE}
	else
		echo "PDE resubmission update process. No error file." | ${MAIL_PROG} -s "PDE Resubmission Update Process" ${MAIL_TO} -a ${RPT_DIR}/pdecl2011-R-${DATE}.pdf
	fi
else
	YEAR=$1
	BATCH_RANGE=$2
	PREFIX=`echo ${BATCH_RANGE} | cut -c9-12`
	S_ERR_FILE="${PDE_DIR}/PDECL2011-ERRORS-${PREFIX}S.csv"
	${SHELL_DIR}/pdecl2011.sh -y ${YEAR} -b ${BATCH_RANGE} ${RXYRFLG} > ${RPT_DIR}/pdecl2011-${DATE} 2>&1
	enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/pdecl2011-${DATE} | ps2pdf - ${RPT_DIR}/pdecl2011-${DATE}.pdf
	if test -s ${S_ERR_FILE}
        then
		echo "PDE update process.  Error file attached." | ${MAIL_PROG} -a ${RPT_DIR}/pdecl2011-${DATE}.pdf -a ${S_ERR_FILE} -s "PDE Update Process" ${MAIL_TO}
	else
		echo "PDE update process.  No error file." | ${MAIL_PROG} -a ${RPT_DIR}/pdecl2011-${DATE}.pdf -s "PDE Update Process" ${MAIL_TO}
	fi
fi

exit 0
