#!/bin/sh
#
# Program Name	: cycle_claim59.sh
# Description	: Claim59 processing procedure
# Author	: Linda S. Jefferis
# Date		: 02/09/2005
# Modifications : 05/05/2005 - Changes for new PRINT-CLAIM59-CYCLE-WW option  (LSJ)
#		: 05/05/2005 - Changes for actual runs for PRINT-CLAIM59-CYCLE-W option  (LSJ)
#		: 06/27/2005 - Added umask command  (LSJ)
#               : 08/05/2005 - Temporarily commented out run of pay1.sh  (LSJ)
#		: 09/15/2005 - New PRINT-CLAIM59-CYCLE-TW file  (LSJ)
#		: 09/16/2005 - Removed logic for PRINT-CLAIM59-CYCLE-WW  (LSJ)
#		: 10/17/2005 - Changes for linux commands  (LSJ)
#		: 11/29/2005 - Changes for new system names  (LSJ)
#		: 01/13/2006 - Stopped the run of pay-week2.sh for SummaCare  (LSJ)
#		: 04/10/2006 - Changed logic to remove PAY_WK_RPT  (LSJ)
#		: 10/13/2008 - Added logic to check status after claim59 runs  (LSJ)
#		: 02/16/2010 - Added run of twice-week1.sh for 15th and last day of month instead of doing this manually each time  (LSJ)
#		: 09/30/2010 - Logic changes for new tweek cycle (X)
#		: 11/08/2010 - Fixes for tweek logic
#		: 03/10/2016 - TT13309-6
#		: 06/02/2016 - TT15075-5 - remove twice-week1.sh logic
#		: 10/31/2017 - TT:3200-169; RETVAL/FATAL ERROR logic.
#		: 12/19/2018 - TT18987-70; CYCLERRS logic
#		: 06/04/2019 - Remove CYCLERR assignements
#		: 11/12/2019 - Change "a2ps" to "enscript"
#		: 06/15/2022 - moved tweek1.sh process ahead of twice1.sh
#
# Variables Used:
PATH=/usr/rmcobol:$PATH
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
PRT_DIR="/usr/lnk/misc"
PAY_RPT="PRINT-CLAIM59-CYCLE-P"
PAYWK_RPT="PRINT-CLAIM59-CYCLE-PW"
TWICE_RPT="PRINT-CLAIM59-CYCLE-T"
TWEEK_RPT="PRINT-CLAIM59-CYCLE-X"
WEEK_RPT="PRINT-CLAIM59-CYCLE-W"
NONE_RPT="PRINT-CLAIM59-CYCLE-N"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
CYCLE_DATE=`date -d "yesterday 0800" +%y%m%d`
MAIL_TO="sgupta@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
OUT_LOG="/tmp/cycle_claim59"
PAGE_PROG="/usr/local/bin/pageuser.sh"
PAGEUSER="linda"
PAGE_MSG="Error with claim59 process"
SUBJECT="Cycle Claim59 - ISSUE/ERROR"
RETVAL=0
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cycle_claim59.sh 

ENDOFUSAGE
  exit 1
}

# Date Conversion
date_conv()
{
	CYCLE_DAY=`echo ${CYCLE_DATE} | cut -c5-6`
}


#
# Main routine
#

umask 002

${SHELL_DIR}/claim59.sh -r 20251231 > ${RPT_DIR}/claim59 2>&1
RETVAL=$?
cat ${RPT_DIR}/claim59 > ${OUT_LOG}

if [ $HOSTNAME = "prod10" ]
then
   if [ $RETVAL -ne 0 ]
   then
	enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/claim59 | ps2pdf - ${RPT_DIR}/claim59.pdf
	$PAGE_PROG "$SUBJECT" "$PAGE_MSG" $PAGEUSER
	echo $PAGE_MSG | ${MAIL_PROG} -s "$SUBJECT" $MAIL_TO -a ${RPT_DIR}/claim59.pdf
	bak ${RPT_DIR}/claim59
	exit $RETVAL
   fi
   grep "COBOL STOP RUN" ${RPT_DIR}/claim59 > /dev/null
   if test $? -ne 0
   then
	$PAGE_PROG "$SUBJECT" "$PAGE_MSG" $PAGEUSER
	echo $PAGE_MSG | ${MAIL_PROG} -s "$SUBJECT" $MAIL_TO	
	bak ${RPT_DIR}/claim59
	exit 99
   fi
   echo "" >> ${OUT_LOG}
   echo "" >> ${OUT_LOG}
   echo "CYCLE INFORMATION" >> ${OUT_LOG}
   echo "" >> ${OUT_LOG}

  ## Pay-cycle ##
   if test -s ${PRT_DIR}/${PAY_RPT}
   then
      cat ${PRT_DIR}/${PAY_RPT} >> ${OUT_LOG}
      mv ${PRT_DIR}/${PAY_RPT} ${PRT_DIR}/pay-${PAY_RPT}
      ${SHELL_DIR}/pay1.sh > ${RPT_DIR}/pay-pay1 2>&1
   fi

  ## Week-cycle ##
   if test -s ${PRT_DIR}/${WEEK_RPT}
   then
      cat ${PRT_DIR}/${WEEK_RPT} >> ${OUT_LOG}
      mv ${PRT_DIR}/${WEEK_RPT} ${PRT_DIR}/wk-${WEEK_RPT}
      ${SHELL_DIR}/week1.sh > ${RPT_DIR}/wk-week1 2>&1
   fi

  ## tweek-cycle ##
   if test -s ${PRT_DIR}/${TWEEK_RPT}
   then
      cat ${PRT_DIR}/${TWEEK_RPT} >> ${OUT_LOG}
      mv ${PRT_DIR}/${TWEEK_RPT} ${PRT_DIR}/tweek-${TWEEK_RPT}
      ${SHELL_DIR}/tweek1.sh > ${RPT_DIR}/tweek-tweek1 2>&1
   fi

  ## Twice-cycle ##
   if test -s ${PRT_DIR}/${TWICE_RPT}
   then
      cat ${PRT_DIR}/${TWICE_RPT} >> ${OUT_LOG}
      mv ${PRT_DIR}/${TWICE_RPT} ${PRT_DIR}/twice-${TWICE_RPT}
      ${SHELL_DIR}/twice1.sh > ${RPT_DIR}/twice-twice1 2>&1
   fi


   if test -s ${PRT_DIR}/${PAYWK_RPT}
   then
	rm -f ${PRT_DIR}/${PAYWK_RPT}
   fi

  ## No cycles ##
   if test -s ${PRT_DIR}/${NONE_RPT}
   then
      cat ${PRT_DIR}/${NONE_RPT} >> ${OUT_LOG}
      rm -f ${PRT_DIR}/${NONE_RPT}
      rm -f ${RPT_DIR}/claim59
   fi 
fi
cat ${OUT_LOG} | ${MAIL_PROG} -s "RUN CYCLE INFORMATION" ${MAIL_TO}

exit 0
