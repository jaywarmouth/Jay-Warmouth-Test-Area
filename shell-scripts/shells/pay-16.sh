#!/bin/ksh
#
# Program Name	: pay-16.sh
# Description	: Pay-Cycle Reporting Section
# Author	: Linda S. Jefferis
# Date		: 04/25/96
# Modifications : 05/29/03 - Added "pay-" to names of rpt files  (LSJ)
#		: 12/29/2015 - TT8641-32; logic for distribution of INVTOTALS file  (LSJ)
#		: 07/28/2020 - CAB:10287 CI:13735; logic to copy file to secondary directory for AWS transfer. (DME)
#
# Variables Used:
CYCLE="null"
INVTOT_DIR=/usr/lnk/misc
TR_ERR=0
ZIP_PROG="/bin/gzip"
OUT_DIR="claims"
SQL_DIR="/usr/lnk/wt/sqlimports"
AWS_DIR="/usr/lnk/wt/oper-wt/CLAIM16"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pay-16.sh 

ENDOFUSAGE
  exit 1
}

#
# Transfer file
file_transfer()
{
if test -e ${FNAME}
then
        ${ZIP_PROG} ${FNAME}
	cp ${FNAME}.gz ${AWS_DIR}
        mv ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "${FNAME} not copied"
                TR_ERR=1
        fi
else
        echo "${FNAME} does not exist"
fi
}


#
# Main routine
#


PERIODEND=`head -1 ${INVTOT_DIR}/???CL16-SYS-INVTOT-P | awk -F, '{print $7}' | cut -c1-8`
SQLIMPORTS=/usr/lnk/sqlimports
cp ${INVTOT_DIR}/???CL16-SYS-INV-P ${SQLIMPORTS}/${OUT_DIR}/D0CL16-SYS-INV-P-${PERIODEND}
FNAME=${SQLIMPORTS}/${OUT_DIR}/D0CL16-SYS-INV-P-${PERIODEND}
file_transfer

cp ${INVTOT_DIR}/???CL16-SYS-INVTOT-P ${SQLIMPORTS}/${OUT_DIR}/INVTOTALS-P-${PERIODEND}
FNAME=${SQLIMPORTS}/${OUT_DIR}/INVTOTALS-P-${PERIODEND}
file_transfer

exit 0
