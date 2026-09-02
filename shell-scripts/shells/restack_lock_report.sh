#!/bin/sh
#
# Program Name  : restack-file-cpy.sh
# Description   : Procedure to email restack lock time report created by JAMS
# Author        : Dawn M. Engler
# Date          : 05/28/2015
#
# Variables Used:
YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
FILE_DIR="/usr/lnk/shares/ftp-tmp/restack"
MAIL_TO="restack@pdmi.com"
MAIL_CC="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
RSTK_RPT="ProductionRestack_${YEAR}_${MONTH}_${DAY}.pdf"

if [ ! -f ${FILE_DIR}/${RSTK_RPT} ];
then
	echo " ${RSTK_RPT} does not exist. Please check Processes and rerun."
	exit 99
else
	echo "Production restack lock time report attached." | ${MAIL_PROG} -a ${FILE_DIR}/${RSTK_RPT} -s "Production Restack Report" -c ${MAIL_CC} ${MAIL_TO}
fi



