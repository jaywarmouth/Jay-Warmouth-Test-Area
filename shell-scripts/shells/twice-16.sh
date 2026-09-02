#!/bin/sh
#
# Program Name	: twice-16.sh
# Description	: Twice-Cycle Invoice procedures
# Author	: Linda S. Jefferis
# Date		: 12/09/2004
# Modifications : 12/08/2011 - Added PDF logic
#		: 01/16/2012 - Fixed issue with missing assigned MISC_DIR
#		: 12/29/2015 - TT8641-32; logic for distribution of INVTOTALS file  (LSJ)
#		: 11/12/2019 - Change "a2ps" to "enscript"
#               : 07/28/2020 - CAB:10287 CI:13735; logic to copy file to secondary directory for AWS transfer. (DME)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
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

usage: twice-16.sh 

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


PERIODEND=`head -1 ${INVTOT_DIR}/???CL16-SYS-INVTOT-T | awk -F, '{print $7}' | cut -c1-8`
SQLIMPORTS=/usr/lnk/sqlimports
cp ${INVTOT_DIR}/???CL16-SYS-INV-T ${SQLIMPORTS}/${OUT_DIR}/D0CL16-SYS-INV-T-${PERIODEND}
FNAME=${SQLIMPORTS}/${OUT_DIR}/D0CL16-SYS-INV-T-${PERIODEND}
file_transfer

cp ${INVTOT_DIR}/???CL16-SYS-INVTOT-T ${SQLIMPORTS}/${OUT_DIR}/INVTOTALS-T-${PERIODEND}
FNAME=${SQLIMPORTS}/${OUT_DIR}/INVTOTALS-T-${PERIODEND}
file_transfer


exit 0
