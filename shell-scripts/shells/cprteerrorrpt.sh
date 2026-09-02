#!/bin/ksh
#
# Program Name	: cprteerrorrpt.sh
# Description	: Distributes the RTE sys0073 .csv error report
#		  Command Line Arguments:
#		  -d <ccyymmdd> - Alternate file date
# Author	: Linda S. Jefferis
# Date		: 03/27/2013
# modifications : 04/03/2013 - TT #3416-36 Folder name change
#		: 04/16/2013 - TT #3416-39 do not upload files with just header record.
#		: 04/26/2013 - Temproarily changed from BizTalk to individuals emails
#		: 06/21/2013 - Changed from Individuals emails back to BizTalk (DME)
#		: 07/17/2013 - Added variable to send notification message to Operations(DME)
#		: 03/10/2016 - TT13309-6
#
#
# Variables Used:
DATE=`date -d "yesterday 0800" +%Y%m%d`
FILE_DIR="/usr/lnk/elig_in/sys0073"
LOG="/usr/lnk/rpt/cprterrrorrpt"
MAIL_TO="BizTalk@pdmi.com"
MAIL_OPS="Operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
FOLDER="HL7_Realtime_Eligibility_Errors"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cprteerrorrpt.sh [-d <ccyymmdd>]
	-d <ccyymmdd>	Alternate file date	(optional)
		By default uses current date

ENDOFUSAGE
  exit 1
}

#
# Set file names
set_filenames()
{
	RTE_FILE="${FILE_DIR}/ELG02-0073-${DATE}.csv"
}


#
# Transfer file
transfer_file()
{
if [ ${HOSTNAME} = "DevTest20" ]
then
	scp -q ${RTE_FILE} prod20:/usr/lnk/wt/business_quality
	if test $? -eq 0
	then
		echo "--> Transfer of ${RTE_FILE} completed." >> ${LOG}
	else
		echo "-*> File transfer failed." >> ${LOG}
		echo "" >> ${LOG}
	fi
fi
if [ ${HOSTNAME} = "prod10" ]
then
	cp ${RTE_FILE} /usr/lnk/wt/hps-12/${FOLDER}
	if test $? -eq 0
        then
                echo "--> Transfer of ${RTE_FILE} to hps-12 completed." >> ${LOG}
        else
                echo "-*> File transfer to hps-12 failed." >> ${LOG}
                echo "" >> ${LOG}
        fi
	cp ${RTE_FILE} /usr/lnk/wt/kkuehls/${FOLDER}
	if test $? -eq 0
        then
                echo "--> Transfer of ${RTE_FILE} to kkuehls completed." >> ${LOG}
        else
                echo "-*> File transfer to kkuehls failed." >> ${LOG}
                echo "" >> ${LOG}
        fi
	echo "Error Report from previous day attached." | ${MAIL_PROG} -a ${RTE_FILE} -s "HL7 Error Report" ${MAIL_TO}
fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	DATE=$1
	;;
  esac
  shift
done

set_filenames

echo "Transfer Procedure for RTE ELG02 csv file" > ${LOG}
date >> ${LOG}
echo "" >> ${LOG}

if test -s ${RTE_FILE}
then
	REC_CNT=`wc -l ${RTE_FILE} | awk '{print $1}'`
	if [ ${REC_CNT} = 0 ]
	then
		echo "-*> The ${RTE_FILE} file only has a header record." >> ${LOG}
		echo "-*> File was not transferred." >> ${LOG}
		echo "" >> ${LOG}
	else
		transfer_file
	fi
else
	echo "-*> The ${RTE_FILE} file does not exist." >> ${LOG}
	echo "-*> No file to transfer." >> ${LOG}
        echo "" >> ${LOG}	
fi

date >> ${LOG}
cat ${LOG} | ${MAIL_PROG} -s "${HOSTNAME} - Distribution of RTE sys0073 error report" ${MAIL_OPS}

exit 0
