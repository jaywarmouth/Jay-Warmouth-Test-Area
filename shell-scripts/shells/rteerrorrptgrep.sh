#!/bin/sh
#
# Program Name	: rteerrorrptgrep.sh
# Description	: grep select error messages to email CDFSupport@pdmi.com
#		  Command Line Arguments:
#		  -d <ccyymmdd> - Alternate file date
# Author	: Linda S. Jefferis
# Date		: 05/23/2016
# Modifications	: 06/02/2016 - TT15172-34; Change MAIL_TO address
#		: 01/02/2018 - TT:17834-7; Changed all logic to use for CDF (sys0171) instead of LASH(sys0080).
#
#
# Variables Used:
DATE=`date -d "yesterday 0800" +%Y%m%d`
FILE_DIR="/usr/lnk/elig_in/sys0171"
RPTFILE="/tmp/sys0171-RTE"
MAIL_TO="cdfsupport@pdmi.com"
MAIL_OPS="Operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rteerrorrptgrep.sh [-d <ccyymmdd>]
	-d <ccyymmdd>	Alternate file date	(optional)
		By default uses current date

ENDOFUSAGE
  exit 1
}

#
# Set file names
set_filenames()
{
	MON=`echo ${DATE} | cut -c5-6`
	DAY=`echo ${DATE} | cut -c7-8`
	YEAR=`echo ${DATE} | cut -c1-4`
	DATE2=$MON$DAY$YEAR
	RTE_FILE="${FILE_DIR}/0171ELRT${DATE2}.${DATE}"
}


#
# GREP file
grep_file()
{
	grep " 1 436 " ${RTE_FILE} >> ${RPTFILE}
	if test $? -ne 0
        then
		echo "*************************************" >> ${RPTFILE}
                echo "-*> No 436 records found" >> ${RPTFILE}
		echo "*************************************" >> ${RPTFILE}
        fi
	grep " 1 439 " ${RTE_FILE} >> ${RPTFILE}
	if test $? -ne 0
        then
		echo "*************************************" >> ${RPTFILE}
                echo "-*> No 439 records found" >> ${RPTFILE}
		echo "*************************************" >> ${RPTFILE}
        fi
	grep " 1 456 " ${RTE_FILE} >> ${RPTFILE}
	if test $? -ne 0
        then
		echo "*************************************" >> ${RPTFILE}
                echo "-*> No 456 records found" >> ${RPTFILE}
		echo "*************************************" >> ${RPTFILE}
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

if test -s ${RTE_FILE}
then
	echo -e "\n\n\n" > ${RPTFILE}
	echo "Information from File: ${RTE_FILE}" >> ${RPTFILE}
	echo "" >> ${RPTFILE}
	grep_file
	a2ps -k -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPTFILE} | ps2pdf - ${RPTFILE}.pdf
	echo "CDF RTE error information for ${DATE2} is attached." | ${MAIL_PROG} -a ${RPTFILE}.pdf -s "CDF RTE Error Information" -c ${MAIL_OPS} ${MAIL_TO}
else
	echo "-*> The ${RTE_FILE} file does not exist." 
	exit 1
fi

exit 0
