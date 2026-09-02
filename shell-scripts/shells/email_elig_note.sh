#!/bin/sh
#
#
# Shell for emailing benefits about new eligibility report files available
# Version 1.3
#	10/22/2009 - Added Don and Colleen to email
#	11/30/2009 - Added check for running on Husk and vlaidation of cd command
#	06/29/2011 - Changed jappod email to hmurphy
#	08/08/2014 - replace ccasey and hmurphy with escaltionteam email (DME)(TT:11704-2)
#	04/18/2018 - add total file count for elig and accum processed (DME)
#	10/03/2018 - Update email to send to CLient service and eligibility and remove Dave R. (dme)
#	10/08/2019 - Update Sharepoint Server and add Link to files on Husk. (DME)
#
#	09/18/2021 - Added zip logic (LSJ)
#	07/30/2025 - bringing logic up to date to remove from JAMS and start running through cron m-f at 7:00pm (DME)
#
usage()
{
        echo "USAGE:"
        echo "email_elig_note.sh"
	exit 1
}



MAIL_PROG="/usr/bin/mutt"
MAIL_TO="Eligibility@pdmi.com,ClientServices@pdmi.com,InternalTPASupport@pdmi.com"
MAIL_CC="operations@pdmi.com"
MAIL_SUB="ELIG REPORTS"
MAIL_TEXT=/tmp/elig_email
FILE_DIR=/usr/lnk/wt/oper-wt/EligReports
LOC_DIR=/usr/lnk/wt/Benefits-Rpts/Elig/
DATE=`date +%Y%m%d`
YEAR=`date +%Y`
P_DATE=`date +%m%d`
ZIP_PROG=/usr/bin/zip


#
# Get File totals
file_totals()
{
	FILE_COUNT=`ls -1  ${DATE}-??????-???????.pdf| wc -l`
	ELIG_COUNT=`ls -1 ${DATE}-??????-??e????.pdf | wc -l`
	ACCUM_COUNT=`ls -1 ${DATE}-??????-??l????.pdf | wc -l`
}


cd ${FILE_DIR}
#Copy files to pickup location
cp *.pdf *.csv *.txt ${LOC_DIR}
if test $? -ne 0
	then
		echo "-*> The directory, $FILE_DIR, does not exist..."
		exit 1
fi


#Get file totals for note
	file_totals

#Create Note text
	echo "The following eligibility reports are available:" > ${MAIL_TEXT}
	echo "LOCATION:  shares on  \\\file30\ClientFiles\Benefits-Rpts\Elig " >> ${MAIL_TEXT}
	echo "" >> ${MAIL_TEXT}
	echo " Total Files Processed: ${FILE_COUNT}" >> ${MAIL_TEXT}
        echo "" >> ${MAIL_TEXT}
	echo " Total eligibility Files Processed: ${ELIG_COUNT}" >> ${MAIL_TEXT}
        echo "" >> ${MAIL_TEXT}
	echo " Total accumulator Files Processed: ${ACCUM_COUNT}" >> ${MAIL_TEXT}
	echo "" >> ${MAIL_TEXT}
	
	ls -t1 *.pdf *.csv >> ${MAIL_TEXT}

	cat ${MAIL_TEXT} | ${MAIL_PROG} -s "${MAIL_SUB}" -c ${MAIL_CC} ${MAIL_TO}
	
${ZIP_PROG} -m /usr/lnk/wt/oper-wt/EligReports/EligReports-${DATE}.zip *.pdf *.csv *.txt

	rm -f ${MAIL_TEXT}

exit 0
