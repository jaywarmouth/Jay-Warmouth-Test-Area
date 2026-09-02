#!/bin/sh
#
# Program Name	: daily_dr340b01.sh  
# Description   : UPDATE DR340B0MAS file.    
# Author	: Linda Jefferis
# Date		: 02/11/2014
# Modifications : 03/04/2014 - Added zero file checking and email (DME)
#		: 03/05/2014 - Added checks and email notification for ERRORS, NOT EQUAL, and VERSION MISMATCH (DME)                                                          
#		: 04/30/2014 - Added eshields and kjackson for error email (DME)
#		: 06/09/2015 - Update script to properly send seperate email notifcations for errors and non errored processing. (TT:6806-42)(DME)
#
#
# Variables Used:
SHELL_DIR=/usr/lnk/shell
RPT_DIR=/usr/lnk/rpt
FILE_DIR=/usr/lnk/wt/oper-wt/340b
DATE=`date +%Y%m%d`
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="Group340b@pdmi.com"
MAIL_CC="operations@pdmi.com"
MAIL_TO_ERR="Group340BErrors@pdmi.com"
MAIL_SUBJ="340B - Daily PriceCatalog File Update"
MAIL_SUBJ_ERR="340B - Daily PriceCatalog File Errors"
YEAR=`date +%Y`
ARCH_DIR=/usr/lnk/elig_in_1/340b/$YEAR
LOG=/tmp/daily_dr340b01
ERR_LOG=/tmp/daily_dr340b01_err

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_dr340b01.sh 

ENDOFUSAGE
  exit 1
}


# Extract information from rpt/dr340b01 for emailing
mail_info()
{
	echo "Information from daily 340B PriceCatalog file update:" > ${LOG}
	echo "" >> ${LOG}
	grep "TOTAL " ${RPT_DIR}/dr340b01 >> ${LOG}
	echo "" >> ${LOG}
	echo "Refer  to \" Daily PriceCatalog  File Errors \" email for error report." >> ${LOG}
	grep " ERRORS " ${RPT_DIR}/dr340b01 >> ${LOG}
}

#
#Create error Report
err_info()
{

#Check group error count
GRP_ERR=$(grep "GROUP ERRORS" ${RPT_DIR}/dr340b01)
GRP_CT=$(echo ${GRP_ERR} | cut -c16-23)
if [ "${GRP_CT}" != "000000" ];
then
        echo ${GRP_ERR} >> ${ERR_LOG}
fi


#Check NABP error count
NABP_ERR=$(grep "NABP  ERRORS" ${RPT_DIR}/dr340b01)
NABP_CT=$(echo ${NABP_ERR} | cut -c15-23)
if [ "${NABP_CT}" != "000000" ];
then
        echo ${NABP_ERR} #>> ${ERR_LOG}
fi


#check NDC error count
NDC_ERR=$(grep "NDC   ERRORS" ${RPT_DIR}/dr340b01)
NDC_CT=$(echo ${NDC_ERR} | cut -c14-23)
if [ "${NDC_CT}" != "000000" ];
then
        echo ${NDC_ERR} >> ${ERR_LOG}
fi

grep "NOT EQUAL" ${RPT_DIR}/dr340b01 >> ${ERR_LOG}
grep "BAD READ" ${RPT_DIR}/dr340b01 >> ${ERR_LOG}
grep " BAD OPEN " ${RPT_DIR}/dr340b01 >> ${ERR_LOG}
grep " NOT ON FILE " ${RPT_DIR}/dr340b01 >> ${ERR_LOG}
grep "**** VERSION MISMATCH ****"  ${RPT_DIR}/dr340b01>> ${ERR_LOG}
}


#
# Archive files
archive_files()
{
	if ! test -d ${ARCH_DIR}
	then
		mkdir -m 770 ${ARCH_DIR}
	fi
	mv ${DR340B0TAP} ${ARCH_DIR}
	mv ${DR340B0AUD} ${ARCH_DIR}
	mv ${DR340B0CSV} ${ARCH_DIR}
	mv ${RPT_DIR}/dr340b01 ${ARCH_DIR}/dr340b01-${DATE}${FTIME}
}


#
# Main routine
#

rm -f ${ERR_LOG}

cd ${FILE_DIR}

FILE=$(ls PriceCatalogACD-${DATE}????.txt )

if test -s "${FILE}"
then
	FTIME=`echo ${FILE} | cut -c25-28`
	echo ${FTIME}
		DR340B0TAP=${FILE}
		export DR340B0TAP

		DR340B0AUD=${FILE_DIR}/PriceCatalogACDaudit-${DATE}${FTIME}.txt
		export DR340B0AUD
		DR340B0CSV=/usr/lnk/tmp/DR340B0CSV-${DATE}${FTIME}.csv
		export DR340B0CSV

		${SHELL_DIR}/dr340b01.sh > ${RPT_DIR}/dr340b01 2>&1
		
		err_info

                if [ -s "${ERR_LOG}" ]
                then
                        echo "error log exists"
                        echo "###################### ERROR MESSAGE #####################" >> ${ERR_LOG}
                        echo "" >> ${ERR_LOG}
                        echo "Review errors and have daily_dr340b01.sh restarted if needed." >> ${ERR_LOG}
                        echo "" >> ${ERR_LOG}
                        echo "#########################################################" >> ${ERR_LOG}

                        sed -i '1s/^/See attached report for details of any indicated errors:\n\n/' ${ERR_LOG}

                        cat ${ERR_LOG} | ${MAIL_PROG} -s "${MAIL_SUBJ_ERR}"  -a ${DR340B0CSV} -c ${MAIL_CC} ${MAIL_TO_ERR} 

                        mail_info
                        cat ${LOG} | ${MAIL_PROG} -s "${MAIL_SUBJ}" -c ${MAIL_CC} ${MAIL_TO}
			rm -f ${ERR_LOG}

                else
                        mail_info
                        echo "${ERR_LOG} does not exists"
                        cat ${LOG} | ${MAIL_PROG} -s "${MAIL_SUBJ}" -c ${MAIL_CC} ${MAIL_TO}
                fi
fi

archive_files

exit 0
