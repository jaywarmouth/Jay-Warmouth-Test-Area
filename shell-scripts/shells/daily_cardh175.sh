#!/bin/sh
#
PATH=/usr/rmcobol:$PATH
SHELL_DIR=/usr/lnk/shell
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
MAIL_PROG="/usr/bin/mutt"
DATE=`date +%Y%m%d`
LOG_FILE="/tmp/daily_cardh175.txt"
RETVAL=0


# Healthwell
hwell_process()
{
PARM_FILE=/usr/lnk/log/cardh175-parm-0175.txt
OUTPUT_FILE=/usr/lnk/tapes/HWELL00CSV-${DATE}.csv
TR_ID="HWELLDaily"
MAILTO="fred.larbi@healthwellfoundation.org,portal@healthwellfoundation.org,healthwell@pdmi.com"
MAILSUBJ="Daily Cardholder/Limit Report"
MAILTEXT="The latest daily cardholder/limit report is available for downloading."

${SHELL_DIR}/cardh175.sh -p ${PARM_FILE} -o ${OUTPUT_FILE} >> ${LOG_FILE} 2>&1
RETVAL=$?
if [ $RETVAL -eq 0 ]
then
        echo "" >> ${LOG_FILE}
        echo "--> Transfer file" >> ${LOG_FILE}
        ${TR_PROG} ${TR_ID} ${OUTPUT_FILE} >> ${LOG_FILE}
        if test $? -ne 0
        then
                echo "-*> Transfer of ${OUTPUT_FILE} failed" | ${MAIL_PROG} -s "FAILURE - File Transfer for daily_cardh175" operations@pdmi.com
        fi
        echo "" >> ${LOG_FILE}
        echo "--> Copy file" >> ${LOG_FILE}
        mv ${OUTPUT_FILE} /usr/lnk/wt/benefit-wt/HWELL >> ${LOG_FILE}

        echo "" >> ${LOG_FILE}
        echo "--> Email Notification" >> ${LOG_FILE}
        echo "${MAILTEXT}" | ${MAIL_PROG} -s "${MAILSUBJ}" ${MAILTO}
else
        echo "-*> Healthwell - Daily cardh175 failed" >> ${LOG_FILE}
fi
}

# PAF Process
paf_process()
{
PARM_FILE=/usr/lnk/log/cardh175-parm-0176.txt
OUTPUT_FILE=/usr/lnk/tapes/LimitSummary-${DATE}.csv
TR_ID="PAF"

${SHELL_DIR}/cardh175.sh -p ${PARM_FILE} -o ${OUTPUT_FILE} >> ${LOG_FILE} 2>&1
RETVAL=$?
if [ $RETVAL -eq 0 ]
then
        echo "" >> ${LOG_FILE}
        echo "--> Transfer file" >> ${LOG_FILE}
        ${TR_PROG} ${TR_ID} ${OUTPUT_FILE} >> ${LOG_FILE}
        if test $? -ne 0
        then
                echo "-*> Transfer of ${OUTPUT_FILE} failed" | ${MAIL_PROG} -s "FAILURE - File Transfer for daily_cardh175" operations@pdmi.com
        fi
	rm ${OUTPUT_FILE}
else
	echo "-*> PAF - Daily cardh175 failed" >> ${LOG_FILE}
fi
}

# PAF-LLS Process
lls_process()
{
PARM_FILE=/usr/lnk/log/cardh175-parm-0185.txt
OUTPUT_FILE=/usr/lnk/tapes/LimitSummary-LLS-${DATE}.csv
TR_ID="LLS"

${SHELL_DIR}/cardh175.sh -p ${PARM_FILE} -o ${OUTPUT_FILE} >> ${LOG_FILE} 2>&1
RETVAL=$?
if [ $RETVAL -eq 0 ]
then
        echo "" >> ${LOG_FILE}
        echo "--> Transfer file" >> ${LOG_FILE}
        ${TR_PROG} ${TR_ID} ${OUTPUT_FILE} >> ${LOG_FILE}
        if test $? -ne 0
        then
                echo "-*> Transfer of ${OUTPUT_FILE} failed" | ${MAIL_PROG} -s "FAILURE - File Transfer for daily_cardh175" operations@pdmi.com
        fi
	rm ${OUTPUT_FILE}
else
	echo "-*> LLS - Daily cardh175 failed" >> ${LOG_FILE}
fi
}

#
# Main routine
# 
echo "Daily CARDH175 process" > ${LOG_FILE}

date >> ${LOG_FILE}

hwell_process

paf_process

lls_process

date >> ${LOG_FILE}

exit ${RETVAL}
