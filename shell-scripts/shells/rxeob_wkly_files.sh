#!/bin/sh
#
# Program Name	: rxeob_wkly_files.sh
# Description	: Runs RxEOB misc data file extracts
# Author	: Linda Jefferis
# Date		: 09/11/2013
# Modifications	: 01/21/2015 - removal of EXCEP process (currently has issue).
#		: 06/18/2015 - Add logic for auto transfer to RxEOB.
#		: 06/18/2015 - As per review list provided by RxEOB, removed LIMIT file creation and process.
#		: 07/14/2020 - Add rxeob_gentb06.sh procedure
#
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
LOG="/tmp/rxeobfiles.log"
FILE_DIR="/usr/lnk/shares/rxeob"
FILE_DATE=`date +%m%d%Y`
TR_ID="RXEOB"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
FILENAME="${FILE_DATE}.zip"
ARCH_DIR="/usr/lnk/rptarch/rxeob"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rxeob_wkly_files.sh 

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

   echo "--> Starting PLAN extract - rxeob_plan.sh" >> ${LOG}
   ${SHELL_DIR}/rxeob_plan.sh >> ${LOG} 2>&1
   echo "--> PLAN extract has completed" >> ${LOG}
   echo "" >> ${LOG}

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

   echo "--> Transfer file to RxEOB" >> ${LOG}
   ${TR_PROG} ${TR_ID} ${FILE_DIR}/${FILENAME} >> ${LOG} 2>&1

   echo "--> Archive transferred file" >> ${LOG}
   mv ${FILE_DIR}/${FILENAME} ${ARCH_DIR} >> ${LOG} 2>&1

${MAIL_PROG} -s "HUSK - RxEOB File Extracts" ${MAIL_TO} < ${LOG}

exit 0
