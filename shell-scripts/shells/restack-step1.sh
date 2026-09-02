#!/bin/sh
#
# Program Name	: restack-step1.sh
# Description	: Procedures for restack03/restack04 
# Author	: Linda S. Jefferis
# Date		: 02/20/2014
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE_DIR="/usr/lnk/tmp"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
CURR_DATE=`date +%Y%m%d`
REMOTE="husk:/usr/lnk/shares/ftp-tmp/restack"
CONFIG_FILE=/usr/lnk/restack/restack.cfg

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: restack-step1.sh 

ENDOFUSAGE
  exit 1
}


#
# Main routine
#
#Check command line validity, call usage if incorrect

${SHELL_DIR}/restack03.sh > ${RPT_DIR}/rst-restack03 2>&1
cd ${FILE_DIR}
RSTKFILE=`ls RESTACK03-${CURR_DATE}??????.txt`
if test $? -ne 0
then
	echo "The file ${FILE_DIR}/${RSTKFILE} does not exist..aborting." | ${MAIL_PROG} -s "Restack Issue" operations@pdmi.com
	exit 1
fi
${SHELL_DIR}/restack04.sh -f ${FILE_DIR}/${RSTKFILE} > ${RPT_DIR}/rst-restack04 2>&1

a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/rst-restack03 | ps2pdf - ${RPT_DIR}/rst-restack03.pdf
a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/rst-restack04 | ps2pdf - ${RPT_DIR}/rst-restack04.pdf

scp ${FILE_DIR}/${RSTKFILE} ${REMOTE}/RESTACK03FILE.txt
scp ${CONFIG_FILE} ${REMOTE}
scp ${RPT_DIR}/rst-restack03 ${REMOTE}
scp ${RPT_DIR}/rst-restack04 ${REMOTE}
scp ${FILE_DIR}/RESTACK03-* ${REMOTE}
scp ${FILE_DIR}/RESTACK04* ${REMOTE}
scp ${CONFIG_FILE} ${REMOTE}

echo "Output from restack-step1.sh process" | ${MAIL_PROG} -a ${RPT_DIR}/rst-restack03.pdf -a ${RPT_DIR}/rst-restack04.pdf -s "Restack Procedures" ${MAIL_TO}

exit 0
