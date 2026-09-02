#!/bin/sh
#
# Program Name	: wh_ncpdpwklyfull.sh
# Description	: Provides NCPDP Master files to Warehouse 
#		  Command Line arguments:
#		  -d <ccyymmdd> - date in filename sent
# Author	: Linda S. Jefferis
# Date		: 08/21/2017
#
# Variables Used:
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="NCPDPWEEKLY/FullFiles"
DEST_DIR="/usr/lnk/sqlimports/misc"
ZIP_DIR="/usr/lnk/wt/oper-wt/ncpdp"
ZIP_PROG="/bin/gzip"
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG=/bin/mail
MAIL_TO="DEDMSupport@pdmi.onmicrosoft.com operations@pdmi.com"
FILE_DATE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wh_ncpdpwklyfull.sh -d <ccyymmdd> 
	-d <ccyymmdd> - required option, use date on zip filename

ENDOFUSAGE
  exit 99
}


#
# Transfer file
file_transfer()
{
if test -e ${FNAME}
then
        ${ZIP_PROG} ${FNAME}
        cp ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "${FNAME} not copied"
                TR_ERR=1
        else
                rm -f ${FNAME}.gz
        fi
else
        echo "${FNAME} does not exist"
fi
}

#
# Set Filenames
set_filenames()
{
	if [ $FILE_DATE = "null" ]
	then
		usage
	fi
	ZIP_FILE="NCPDP_v3.1_Weekly_Master_${FILE_DATE}.ZIP"
	if ! test -s ${ZIP_DIR}/${ZIP_FILE}
	then
		echo "-*> ${ZIP_DIR}/${ZIP_FILE} is zero or does not exist"
		exit 99
	fi
	NCPDP[1]="mas.txt"
	NCPDP[2]="mas_rr.txt"
	NCPDP[3]="mas_tx.txt"
	NCPDP[4]="mas_af.txt"
	NCPDP[5]="mas_md.txt"
	NCPDP[6]="mas_pc.txt"
	NCPDP[7]="mas_pr.txt"
	NCPDP[8]="mas_erx.txt"
	NCPDP[9]="mas_coo.txt"
	NCPDP[10]="mas_rec.txt"
	NCPDP[11]="mas_stl.txt"
	NCPDP[12]="mas_svc.txt"
	NCP_OUT[1]="NCPTP20TAP-FULL-${FILE_DATE}"
	NCP_OUT[2]="NCPPR00TAP-FULL-${FILE_DATE}"
	NCP_OUT[3]="NCPTX00TAP-FULL-${FILE_DATE}"
	NCP_OUT[4]="NCPRD00TAP-FULL-${FILE_DATE}"
	NCP_OUT[5]="NCPMED0TAP-FULL-${FILE_DATE}"
	NCP_OUT[6]="NCPPA20TAP-FULL-${FILE_DATE}"
	NCP_OUT[7]="NCPPO00TAP-FULL-${FILE_DATE}"
	NCP_OUT[8]="NCPEPR0TAP-FULL-${FILE_DATE}"
	NCP_OUT[9]="NC3CO00TAP-FULL-${FILE_DATE}"
	NCP_OUT[10]="NC3RR00TAP-FULL-${FILE_DATE}"
	NCP_OUT[11]="NC3SL00TAP-FULL-${FILE_DATE}"
	NCP_OUT[12]="NC3SI00TAP-FULL-${FILE_DATE}"
	MAXFILES=12
}

#
# Unzip files
unzip_files()
{
	${UNZIP_PROG} -j -d ${DEST_DIR} ${ZIP_DIR}/${ZIP_FILE}
	rm -f ${DEST_DIR}/mas_fwa.txt
}

#
# Copy files
copy_files()
{
   i=1
   while [ $i -le ${MAXFILES} ]
   do
	mv ${DEST_DIR}/${NCPDP[i]} ${DEST_DIR}/${NCP_OUT[i]}
	let i=i+1
   done
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
        FILE_DATE=$1
        ;;
esac
  shift
done

set_filenames

echo
echo "--> Unzip files..."
echo
unzip_files

echo
echo "--> Copying files"
echo
copy_files

LOG_NAME=/tmp/ncpdp.log
cd ${DEST_DIR}
echo "The Weekly Master/Full NCPDP files are available for importing."  > ${LOG_NAME}
echo "" >> ${LOG_NAME}
echo -e "Filename\t\t\t\t Record Count"  >> ${LOG_NAME}
i=1
while [ $i -le ${MAXFILES} ]
do
	NCPDP_FILE=${DEST_DIR}/${NCP_OUT[i]}
	REC_CNT=`wc -l ${NCPDP_FILE} | awk '{print $1}'`
	echo -e "${NCP_OUT[i]}\t\t\t ${REC_CNT}" >> ${LOG_NAME}
        FNAME=${NCPDP_FILE}
        file_transfer
	let i=i+1
done

cat ${LOG_NAME} | ${MAIL_PROG} -s "Weekly NCPDP Notification" ${MAIL_TO}


exit 0
