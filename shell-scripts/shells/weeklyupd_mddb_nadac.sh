#!/bin/sh
# Modifications : 11/05/2025 added call to drprc13.sh for DRUG000MAS update from NADAC file for record type 32.
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
PATH=/usr/rmcobol:$PATH
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com,clinicalsupport@pdmi.com"
BUCKET_NAME="ga-internal-transfers"
FILE_PATH="PDMI/MEDISPAN/NADAC/INTERNAL/Weekly/"
AWS_DIR="$BUCKET_NAME/$FILE_PATH"
AWS_MV="/usr/local/bin/aws s3 mv"
DATE=`date +%Y%m%d`
FILE_DIR=/usr/upd/drug
NADAC_FILE=${FILE_DIR}/NADACUPDT

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: weeklyupd_mddb_nadac.sh 

ENDOFUSAGE
  exit 1
}

#
transfer_file()
{
  ${AWS_MV} s3://${AWS_DIR} ${FILE_DIR} --recursive --only-show-errors > ${RPT_DIR}/weeklyupd_mddb_nadac
  cd ${FILE_DIR}
  ls -1 NADACPricing* > /tmp/nadacfilelisting.txt
  #FILE_CNT=`wc -l /tmp/nadacfilelisting.txt`  
  for file in `cat /tmp/nadacfilelisting.txt`
  do
	mv ${FILE_DIR}/${file} ${NADAC_FILE} >> ${RPT_DIR}/weeklyupd_mddb_nadac
  done
}

#
cleanup()
{
	mv ${NADAC_FILE} ${NADAC_FILE}-${DATE}
        cat ${RPT_DIR}/weeklyupd_mddb_nadac | ${MAIL_PROG} -s "WEEKLY MDDB-NADAC" ${MAIL_TO}
}	


#
# Main routine
#

# Check command line validity, call usage if incorrect


umask 000

transfer_file

find ${FILE_DIR} -name "NADACUPDT*" -mtime +30 -exec rm -f {} \;

if test -s ${NADAC_FILE}
then

	echo "--> Starting drprc13 process" >> ${RPT_DIR}/weeklyupd_mddb_nadac 2>&1
        echo "" >> ${RPT_DIR}/weeklyupd_mddb_nadac
        ${SHELL_DIR}/drprc13.sh >> ${RPT_DIR}/weeklyupd_mddb_nadac 2>&1
        if test $? -ne 0
        then
                echo "The drprc13 process FAILED" >> ${RPT_DIR}/weeklyupd_mddb_nadac
                cleanup
                exit 99
        fi
	echo "--> Starting drprc12 process" >> ${RPT_DIR}/weeklyupd_mddb_nadac 2>&1
	echo "" >> ${RPT_DIR}/weeklyupd_mddb_nadac
	${SHELL_DIR}/drprc12.sh -i ${NADAC_FILE} >> ${RPT_DIR}/weeklyupd_mddb_nadac 2>&1
	if test $? -ne 0
	then
		echo "The drprc12 process FAILED" >> ${RPT_DIR}/weeklyupd_mddb_nadac
		cleanup
		exit 99
	fi
	${SHELL_DIR}/drprc15.sh >> ${RPT_DIR}/weeklyupd_mddb_nadac 2>&1
	if test $? -ne 0
        then
		echo "The drprc15 process FAILED" >> ${RPT_DIR}/weeklyupd_mddb_nadac 
		cleanup
		exit 99
	fi
	cleanup
else
	echo "Weekly NADAC file, ${NADAC_FILE}, not available for updating" | ${MAIL_PROG} -s "WEEKLY MDDB-NADAC" ${MAIL_TO}
fi

exit 0
