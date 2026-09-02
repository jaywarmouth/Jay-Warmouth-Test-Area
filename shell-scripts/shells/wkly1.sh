#!/bin/ksh
#
# Program Name	: wkly1.sh
# Description	: Does batch run of cardh09, cardhup080.sh and extract procedure
#		  NOTE: dates on cardhup080.sh need changed each month.
# Author	: Linda Jefferis
# Date		: 02/26/97
# Modifications : 05/18/2000 - Added card80_rbextract.sh  (LSJ)
#		: 04/11/2001 - Added mailing procedure  (LSJ)
#		: 08/07/2001 - Added cardh09 procedure  (LSJ)
#		: 10/26/2005 - Changes for Linux  (LSJ)
#		: 02/27/2006 - Added umask command  (LSJ)
#		: 09/08/2008 - Added PRINTER variable (LSJ)
#		: 05/20/2010 - Remove lp and added PDF conversion and email of report logic
#		: 01/03/2020 - Task #4534-12
#		: 01/31/2020 - Task #13915-86
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="ljefferis@pdmi.com"
MAIL_WH="warehouse@pdmi.com"
LOG="/tmp/wkly1.log"
YR_MONTH=`date +%Y%m`
YEAR=`date +%Y`
PATH=/usr/rmcobol:$PATH

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wkly1.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

umask 002

echo `date` > ${LOG}
echo "--> Starting cardh09" >> ${LOG}
${SHELL_DIR}/cardh09.sh > ${RPT_DIR}/cardh09 2>&1
echo "" >> ${LOG}
echo "--> cardh09 has completed" >> ${LOG}
echo `date` >> ${LOG}

echo "--> Starting cardhup080" >> ${LOG}
rm -f ${MISC_DIR}/CARDH80.rpt ${MISC_DIR}/CARDH80-rpt.pdf
${SHELL_DIR}/cardhup080.sh -m ${YR_MONTH} -y ${YEAR} > ${RPT_DIR}/cardhup080 2>&1
echo "" >> ${LOG}
echo "--> cardhup080 has completed" >> ${LOG}
echo `date` >> ${LOG}
echo "" >> ${LOG}
${SHELL_DIR}/card80_rbextract.sh >> ${LOG} 2>&1
echo "" >> ${LOG}

echo "--> Starting cardhup081" >> ${LOG}
rm -f ${MISC}/CARDH81.rpt ${MISC}/CARDH81-rpt.pdf
${SHELL_DIR}/cardhup081.sh -y ${YEAR} > ${RPT_DIR}/cardhup081 2>&1
echo "" >> ${LOG}
echo "--> cardhup081 has completed" >> ${LOG}
echo `date` >> ${LOG}
echo "" >> ${LOG}
${SHELL_DIR}/card81_extract.sh > ${RPT_DIR}/card81_extract 2>&1
echo "--> card81_extract has completed" >> ${LOG}
echo `date` >> ${LOG}

${MAIL_PROG} -s "Weekly CARD80" ${MAIL_TO} < ${LOG}

enscript -r -o - ${MISC_DIR}/CARDH80.rpt | ps2pdf - ${MISC_DIR}/CARDH80-rpt.pdf
enscript -r -o - ${MISC_DIR}/CARDH81.rpt | ps2pdf - ${MISC_DIR}/CARDH81-rpt.pdf
echo "The weekly CARDH80/CARD81 process is completed." | ${MAIL_PROG} -s "Weekly CARDH80i/CARD81" -a ${MISC_DIR}/CARDH80-rpt.pdf -a ${MISC_DIR}/CARDH81-rpt.pdf ${MAIL_WH}

exit 0
