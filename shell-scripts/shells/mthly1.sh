#!/bin/ksh
#
# Program Name	: mthly1.sh
# Description	: Does run of cardhup081.sh and the extract
#                 Command line arguments:
#			-x Flag to run cardhup080 also
# Author	: Linda Jefferis
# Date		: 03/12/2001
# Modifications : 10/26/2005 - Changes for Linux  (LSJ)
#		: 09/08/2008 - Added PRINTER variable with new printer  (LSJ)
#		: 12/03/2008 - Added "-x" logic  (LSJ)
#		: 05/20/2010 - Removed lp and added PDF conversion and email of reports
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="ljefferis@pdmi.com"
MAIL_WH="warehouse@pdmi.com"
LOG="/tmp/mthly1.log"
RUN_CARDH80=0
YR_MONTH=`date +%Y%m`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mthly1.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -x) RUN_CARDH80=1
	;;
esac
  shift
done

echo `date` > ${LOG}
echo "--> Starting cardh09" >> ${LOG}
${SHELL_DIR}/cardh09.sh > ${RPT_DIR}/cardh09 2>&1
echo "" >> ${LOG}
echo "--> cardh09 has completed" >> ${LOG}
echo `date` >> ${LOG}
echo "--> Starting cardhup081" >> ${LOG}
rm -f ${MISC}/CARDH81.rpt ${MISC}/CARDH81-rpt.pdf
${SHELL_DIR}/cardhup081.sh > ${RPT_DIR}/cardhup081 2>&1
echo "" >> ${LOG}
echo "--> cardhup081 has completed" >> ${LOG}
echo `date` >> ${LOG}
echo "" >> ${LOG}
${SHELL_DIR}/card81_extract.sh > ${RPT_DIR}/card81_extract 2>&1
echo "--> card81_extract has completed" >> ${LOG}
echo `date` >> ${LOG}
echo "" >> ${LOG}

${MAIL_PROG} -s "Monthly CARD81" ${MAIL_TO} < ${LOG}

a2ps -1Bl132 -o - ${MISC_DIR}/CARDH81.rpt | ps2pdf - ${MISC_DIR}/CARDH81-rpt.pdf
echo "The monthly CARDH81 process is completed." | ${MAIL_PROG} -s "Monthly CARDH81" -a ${MISC_DIR}/CARDH81-rpt.pdf ${MAIL_WH}

if [ $RUN_CARDH80 = 1 ]
then
	echo `date` > ${LOG}
	rm -f ${MISC_DIR}/CARDH80.rpt ${MISC_DIR}/CARDH80-rpt.pdf	
	echo "--> Starting cardhup080" >> ${LOG}
	${SHELL_DIR}/cardhup080.sh -m ${YR_MONTH} > ${RPT_DIR}/cardhup080 2>&1
	echo "" >> ${LOG}
	echo "--> cardhup080 has completed" >> ${LOG}
	echo `date` >> ${LOG}
	echo "" >> ${LOG}
	${SHELL_DIR}/card80_rbextract.sh >> ${LOG} 2>&1
	echo "" >> ${LOG}

	${MAIL_PROG} -s "Weekly CARD80" ${MAIL_TO} < ${LOG}

	a2ps -1Bl132 -o - ${MISC_DIR}/CARDH80.rpt | ps2pdf - ${MISC_DIR}/CARDH80-rpt.pdf
	echo "The weekly CARDH80 process is completed." | ${MAIL_PROG} -s "Weekly CARDH80" -a ${MISC_DIR}/CARDH80-rpt.pdf ${MAIL_WH}
fi

exit 0
