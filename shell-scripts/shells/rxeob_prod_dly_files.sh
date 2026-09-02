#!/bin/sh
#
# Program Name	: rxeob_prod_dly_files.sh
# Description	: Runs RxEOB misc data file extracts on Production server
#
#
# Variables Used:
PATH=/usr/rmcobol:$PATH
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
LOG="/tmp/rxeobfiles.log"
FILE_DIR="/usr/lnk/wt/oper-wt/RxEOB"
FILE_DATE=`date +%m%d%Y`
TR_ID="RXEOB-GA"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
FILENAME="${FILE_DATE}.zip"
ARCH_DIR="/usr/lnk/rptarch/rxeob"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rxeob_prod_wkly_files.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

umask 002

echo `date` > ${LOG}

   echo "--> Starting ELIG extract - rxeob_elig.sh" >> ${LOG}
   ${SHELL_DIR}/rxeob_elig.sh >> ${LOG}  2>&1
   echo "--> ELIG extract has completed" >> ${LOG}
   echo "" >> ${LOG}

   echo "--> Starting GROUP extract - rxeob_grp.sh" >> ${LOG}
   ${SHELL_DIR}/rxeob_grp.sh >> ${LOG} 2>&1
   echo "--> GROUP extract has completed" >> ${LOG}
   echo "" >> ${LOG}

   echo "--> Starting PHNET extract - rxeob_phnet.sh" >> ${LOG}
   ${SHELL_DIR}/rxeob_phnet.sh >> ${LOG}  2>&1
   echo "--> PHNET extract has completed" >> ${LOG}
   echo "" >> ${LOG}

   echo "--> Starting GENTB06 extract - rxeob_gentb06.sh" >> ${LOG}
   ${SHELL_DIR}/rxeob_gentb06.sh >> ${LOG}  2>&1
   echo "--> GENTB06 extract has completed" >> ${LOG}
   echo "" >> ${LOG}

#   echo "--> Starting PLAN extract - rxeob_plan.sh" >> ${LOG}
#   ${SHELL_DIR}/rxeob_plan.sh >> ${LOG} 2>&1
#   echo "--> PLAN extract has completed" >> ${LOG}
#   echo "" >> ${LOG}

   echo "--> Starting COPAY extract - rxeob_copay.sh" >> ${LOG}
   ${SHELL_DIR}/rxeob_copay.sh >> ${LOG} 2>&1
   echo "--> COPAY extract has completed" >> ${LOG}
   echo "" >> ${LOG}

   echo "--> Starting MAC extract - rxeob_mac.sh" >> ${LOG}
   ${SHELL_DIR}/rxeob_mac.sh >> ${LOG} 2>&1
   echo "--> MAC extract has completed" >> ${LOG}
   echo "" >> ${LOG}

   echo "--> Starting PHARM01 extract - pharm01.sh"  >> ${LOG}
   ${SHELL_DIR}/rxeob_pharm01.sh >> ${LOG} 2>&1
   echo "--> PHARM01 extract has completed" >> ${LOG}
   echo "" >> ${LOG}

   echo "--> Starting OVERRIDE extract - rxeob_override.sh"  >> ${LOG}
   ${SHELL_DIR}/rxeob_override.sh >> ${LOG} 2>&1
   echo "--> OVERRIDE extract has completed" >> ${LOG}
   echo "" >> ${LOG}

   echo "--> Starting GPI5001-6001 extract - rxeob_genpc002.sh"  >> ${LOG}
   ${SHELL_DIR}/rxeob_genpc002.sh >> ${LOG} 2>&1
   echo "--> GPI5001-6001 extract has completed" >> ${LOG}
   echo "" >> ${LOG}

   ERRCHK=`grep -a -c "error" $LOG`
   if [ $ERRCHK = 0 ]
   then
   	echo "--> Transfer file to RxEOB" >> ${LOG}
   	${TR_PROG} ${TR_ID} ${FILE_DIR}/${FILENAME} >> ${LOG} 2>&1
   else
	echo "One or more extract processes had errors.  The file, ${FILE_DIR}/${FILENAME}, was not distributed to RxEOB" >> ${LOG} 2>&1
   fi

   echo "--> Archive transferred file" >> ${LOG}
   mv ${FILE_DIR}/${FILENAME} ${ARCH_DIR} >> ${LOG} 2>&1

${MAIL_PROG} -s "Prod10 - RxEOB File Extracts" ${MAIL_TO} < ${LOG}

exit 0
