#!/bin/sh
#
# Program Name	: ncpdp_master.sh
# Description	: Moves and creates log listing of NCPDP Master files 
#		  Command Line arguments:
#		  -d <ccyymmdd> - date in filename sent
#		  -t Test mode flag
# Author	: Linda S. Jefferis
# Date		: 08/21/2017
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DEST_DIR=/usr/upd/pharm
REMOTE_2="robin"
ZIP_DIR="/usr/lnk/wt/oper-wt/ncpdp"
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG=/bin/mail
MAIL_TO="pharmacy@pdmi.com operations@pdmi.com"
TEST=0
FILE_DATE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ncpdp_master.sh -d <ccyymmdd> -t
	-d <ccyymmdd> - required option, use date on zip filename
	-t	- optional, used for test run to send files to Robin

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    IFS=${OLDIFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
	IFS=${EQUAL}
	set $VAR
	NVAR=$1
	export ${NVAR}
        if [ $? -ne 0 ]
        then
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

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
	NCP_OUT[1]="NCPTP20TAP"
	NCP_OUT[2]="NCPPR00TAP"
	NCP_OUT[3]="NCPTX00TAP"
	NCP_OUT[4]="NCPRD00TAP"
	NCP_OUT[5]="NCPMED0TAP"
	NCP_OUT[6]="NCPPA20TAP"
	NCP_OUT[7]="NCPPO00TAP"
	NCP_OUT[8]="NCPEPR0TAP"
	NCP_OUT[9]="NC3CO00TAP"
	NCP_OUT[10]="NC3RR00TAP"
	NCP_OUT[11]="NC3SL00TAP"
	NCP_OUT[12]="NC3SI00TAP"
	MAXFILES=12
}

#
# Unzip files
unzip_files()
{
	${UNZIP_PROG} -j -d ${ZIP_DIR} ${ZIP_DIR}/${ZIP_FILE}
}

#
# Copy files
copy_files()
{
   i=1
   while [ $i -le ${MAXFILES} ]
   do
	if [ ${TEST} = 1 ]
	then
		scp ${ZIP_DIR}/${NCPDP[i]} ${REMOTE_2}:${DEST_DIR}/${NCP_OUT[i]}
	else
		cp ${ZIP_DIR}/${NCPDP[i]} ${DEST_DIR}/${NCP_OUT[i]}
	fi
	let i=i+1
   done
}

#
# Cleanup
cleanup()
{
   i=1
   while [ $i -le ${MAXFILES} ]
   do
	rm ${ZIP_DIR}/${NCPDP[i]}
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
    -t) TEST=1
	;;
esac
  shift
done

parse_env

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
echo "The Master(Full) NCPDP files are available for processing."  > ${LOG_NAME}
echo "" >> ${LOG_NAME}
echo -e "Filename\t Record Count"  >> ${LOG_NAME}
i=1
while [ $i -le ${MAXFILES} ]
do
	NCPDP_FILE=${ZIP_DIR}/${NCPDP[i]}
	REC_CNT=`wc -l ${NCPDP_FILE} | awk '{print $1}'`
	echo -e "${NCP_OUT[i]}\t ${REC_CNT}" >> ${LOG_NAME}
	let i=i+1
done

if [ ${TEST} = 0 ]
then
   cat ${LOG_NAME} | ${MAIL_PROG} -s "MasterFile NCPDP Notification" ${MAIL_TO}
fi

cleanup

exit 0
