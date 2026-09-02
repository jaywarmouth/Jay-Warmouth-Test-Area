#!/bin/sh
#
# Variables Used:
LOG=/tmp/claim96info.log
PROCLOG=/tmp/analyzeclaim96.log
RPTFILE=/usr/lnk/rpt/claim96
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"


# Update Information
upd_info()
{
STATUS98CNT=`grep "STATUS-CODE 98" ${RPTFILE} | wc -l`
ERR98CNT=`grep "I-O: 9802" ${RPTFILE} | wc -l`
FATALERRCNT=`grep "* CLAIM96 - FATAL ERROR       *" ${RPTFILE} | wc -l`
ERR24CNT=`grep "STATUS-CODE 24" ${RPTFILE} | wc -l`
echo "Number of Status 98 Error Messages:  ${STATUS98CNT}" >> $LOG
echo "Number of 9802 Error Messages:  ${ERR98CNT}" >> $LOG
echo "Number 0f 24 Error Messages:  ${ERR24CNT}" >> $LOG
echo "Number of Claims WRITTEN:  `grep " WRITTEN" ${RPTFILE} | wc -l`" >> $LOG
echo "Number of Claims REWRITTEN:  `grep "REWRITTEN" ${RPTFILE} | wc -l`" >> $LOG
echo "Number of CLMSG Processed:  `grep "CMG CLAIM:" ${RPTFILE} | wc -l`" >> $LOG
echo "Number of CLMSS Processed:  `grep "CLMSS: " ${RPTFILE} | wc -l`" >> $LOG
}

# Email log
send_email()
{
	cat $PROCLOG | ${MAIL_PROG} -s "Husk Morning Claim96" ${MAIL_TO}
}


## Main Section

upd_info

if [ $FATALERRCNT -gt 0 ]
then
	STATUS="*** ERRORS ***"
        echo /usr/lnk/shell/filefix.sh | at now +1 minute
else
	if [ $ERR98CNT -gt 0 -o $STATUS98CNT -gt 0 ]
	then
		STATUS="*** ERRORS ***"
		echo /usr/lnk/shell/filefix.sh | at now +1 minute
	else
		STATUS="Completed"
	fi
fi

echo "Process Result: ${STATUS}" > $PROCLOG
echo "" >> $PROCLOG
cat $LOG >> $PROCLOG
send_email

rm -f $LOG $PROCLOG

exit 0
