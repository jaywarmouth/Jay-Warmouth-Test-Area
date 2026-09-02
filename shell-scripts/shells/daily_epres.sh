#!/bin/ksh
#
# Program Name	: daily_epres.sh
# Description	: Runs daily procedures for E-Prescribing
# Author	: Linda Jefferis
# Date		: 03/19/2009
# Modifications : 03/25/2015 - TT #13309-4
#		: 03/17/2017 - Corrected cleanup section issue with directory name. (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_TO="operator@pdmi.com"
LOG="/tmp/dly_epres.log"
YESTERDAY=`date -d "yesterday 0800" +%Y%m%d`
EPRES01_DATE=`date -d "2 days ago 0800" +%Y%m%d`
FLEX="/usr/lnk/flexgen"
EPRES_DIR="/usr/lnk/e-pres/batch"
EPRES_FILE="EPRES01-${YESTERDAY}"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="RXHUB"
CAWRK="${EPRES_DIR}/CAWRK-EPRES"
ARCH_CAWRK="${EPRES_DIR}/CAWRK-EPRES-${YESTERDAY}"
EPRES01_CAWRK="${EPRES_DIR}/CAWRK-EPRES-${EPRES01_DATE}"
EPRES01TAP="${EPRES_DIR}/${EPRES_FILE}"
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
ARCH_DIR="/usr/lnk/rptarch/daily"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_epres.sh 

ENDOFUSAGE
  exit 1
}

# Error Email
send_error_email()
{
	cat ${RPT_DIR}/epres01 >> ${LOG}
	${MAIL_PROG} -s "DAILY E-PRESCRIPING PROCESS - ERROR ${EXIT_STATUS}" ${MAIL_TO} < ${LOG}
}

# Pull CAWRK process
cawrk_process()
{
	echo "--> Starting CARD Extract procedure" >> ${LOG}
	${SHELL_DIR}/epres06.sh > ${RPT_DIR}/epres06 2>&1
	if test -s ${CAWRK}
	then
		mv ${CAWRK} ${ARCH_CAWRK}
		echo "The file, ${ARCH_CAWRK}, is now available." >> ${LOG}
	else
		echo "-*> There was a problem with the epres06.sh process." >> ${LOG}
	fi
	cat ${RPT_DIR}/epres06 >> ${LOG}
}

# Create epres01 file
epres01_process()
{
	echo "--> Starting Daily batch eligibility procedure" >> ${LOG}
	${SHELL_DIR}/epres01.sh -x ${EPRES01_CAWRK} -o ${EPRES01TAP} > ${RPT_DIR}/epres01 2>&1
	if test $? -ne 0
	then
        	EXIT_STATUS=1
        	echo "-*> The epres01 program had an ERROR..." >> ${LOG}
        	echo "-*> NO file was sent to RXHUB." >> ${LOG}
		echo "Displayed errors from the EPRES01 process follows..."  >> ${LOG}
        	send_error_email
        	exit 1
	fi
	echo "--> epres01 has completed. The displayed output follows..." >> ${LOG}
	cat ${RPT_DIR}/epres01 >> ${LOG}
}

# Transfer File
transfer_process()
{
	echo "--> File transfer Process" >> ${LOG}
	if test -e ${EPRES01TAP}
	then
        	scp -q ${EPRES01TAP} ${REMOTE_SYS}:${REMOTE_DIR}
        	if test $? -ne 0
        	then
                	echo "-*> Remote copy of ${EPRES01TAP} failed..." >> ${LOG}
                	echo "-*>  NO file was sent to RXHUB." >> ${LOG}
                	EXIT_STATUS=2
                	send_error_email
        	fi
        	ssh -q ${REMOTE_SYS} "${TR_PROG} ${TR_ID} ${REMOTE_DIR}/${EPRES_FILE}" >> ${LOG}
		echo "--> Transfer of file to RXHUB is completed" >> ${LOG}
	else
        	echo "-*> The ${EPRES01TAP} file does not exist..." >> ${LOG}
        	echo "-*> NO file was sent to RXHUB." >> ${LOG}
        	EXIT_STATUS=2
        	send_error_email
        	exit 2
	fi
}

#
# Cleanup
cleanup()
{
	gzip ${EPRES01_CAWRK}
	ssh -q ${REMOTE_SYS} "mv ${REMOTE_DIR}/${EPRES_FILE} ${ARCH_DIR}" >> ${LOG}
	find ${EPRES_DIR} -follow -name "CAWRK-EPRES-*" -mtime +7 -exec rm {} \;
	find ${EPRES_DIR} -follow -name "EPRES01-????????" -mtime +7 -exec rm {} \;
}


#
# Main routine
#

umask 002

echo `date` > ${LOG}

cawrk_process
echo "" >> ${LOG}
echo `date` >> ${LOG}

epres01_process
echo "" >> ${LOG}
echo `date` >> ${LOG}

transfer_process
echo "" >> ${LOG}
echo `date` >> ${LOG}

cleanup

${MAIL_PROG} -s "DAILY E-PRESCRIBING PROCESS" ${MAIL_TO} < ${LOG}

exit 0
