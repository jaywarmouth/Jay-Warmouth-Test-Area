#!/bin/sh
#
# Program Name	: ncpdp_lst.sh
# Description	: Moves and creates log listing of NCPDP files 
#		  Command Line arguments:
#		  -d <ccyymmdd> - date in filename sent
#		  -f Full file process flag
#		  -t Test mode flag
# Author	: Linda S. Jefferis
# Date		: 03/25/1998
# Modifications : 07/11/2000 - Changed logic to move and convert files in additon to producing log listing.  (LSJ)
#		: 10/09/2000 - Added logic to rcp files to Raven  (LSJ)
#		: 07/03/2002 - Added unzip procedure  (LSJ)
#		: 06/17/2003 - Added logic for once a year full file with differnet name  (LSJ)
#		: 10/20/2005 - Changes for linux  (LSJ)
#		: 11/29/2005 - Changes for new system names  (LSJ)
#		: 01/02/2006 - Changed lp to mail  (LSJ)
#		: 03/23/2006 - Changed email from benefits to pharmacy  (LSJ)
#		: 01/29/2007 - Changes for new Version 2.1 files  (LSJ)
#		: 02/05/2007 - Added NCP_OUT logic  (LSJ)
#		: 02/12/2007 - Moved copy-files up before log and email logic  (LSJ)
#		: 03/02/2007 - Added Mike Paulus to email notification  (LSJ)
#		: 06/04/2008 - Changed ljefferis@pdmi.com to operations@pdmi.com  (LSJ)
#		: 06/30/2008 - Added test mode flag  (LSJ)
#		: 10/02/2008 - Change zip file names from NCPDP  (LSJ)
#		: 12/02/2008 - Added Warehouse to email (LSJ)
#		: 01/09/2009 - eliminated some email text when TEST option not used  (LSJ)
#		: 09/04/2009 - Changed email for normal run and also copying files to Robin  (LSJ)
#		: 12/02/2009 - Added new v2.2 ERX file and scp to prod10
#		: 01/07/2010 - Changes to retrieve ERX file from "Master" zip file; it is not included in the "Transaction" zip file as per Rebecca at NCPDP
#		: 03/16/2010 - Changes for new FILE10-FILE20 file location for warehouse access
#		: 10/06/2010 - Temporarily re-added scp of files to Prod20
#		: 01/12/2011 - Removed scp to Prod20
#		: 06/19/2013 - Changes for NCPDP Version 3.0 files
#		: 05/06/2014 - Changes for no longer using ncpdp-ftp area.
#		: 08/19/2015 - TT:13915-5
#		: 04/03/2017 - TT17093-2
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DEST_DIR=/usr/upd/pharm
REMOTE_2="robin"
REMOTE_3="prod10"
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

usage: ncpdp_lst.sh -d <ccyymmdd> -f -t
	-d <ccyymmdd> - required option, use date on zip filename
	-f 	- optional, used if full Master file
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
	ZIP_FILE_MASTER="NCPDP_v3.0_Monthly_Master_${FILE_DATE}.ZIP"
	ZIP_FILE_TRAN="NCPDP_v3.0_Monthly_Transaction_${FILE_DATE}.ZIP"
	if ! test -s ${ZIP_DIR}/${ZIP_FILE_MASTER}
	then
		echo "-*> ${ZIP_DIR}/${ZIP_FILE_MASTER} is zero or does not exist"
		exit 1
	fi
	if ! test -s ${ZIP_DIR}/${ZIP_FILE_TRAN}
	then
		echo "-*> ${ZIP_DIR}/${ZIP_FILE_TRAN} is zero or does not exist"
		exit 1
	fi
	if [ "$FULL" = "1" ]
	then
		NCPDP[1]="mas.txt"
	else
		NCPDP[1]="trn.txt"
	fi
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
	if [ "$FULL" = "1" ]
        then
		${UNZIP_PROG} -j -d ${ZIP_DIR} ${ZIP_DIR}/${ZIP_FILE_MASTER}
	else
		${UNZIP_PROG} -j -d ${ZIP_DIR} ${ZIP_DIR}/${ZIP_FILE_TRAN}
	fi
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
		scp ${ZIP_DIR}/${NCPDP[i]} ${REMOTE_3}:${DEST_DIR}/${NCP_OUT[i]}
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
    -f) FULL=1
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

LOG_NAME=ncpdp.log
cd ${DEST_DIR}
if [ "$FULL" = "1" ]
then
	echo "The FULL NCPDP files sre available for processing." > ${LOG_NAME}
else
	echo "The monthly Add/Change NCPDP files are available for processing."  > ${LOG_NAME}
fi
echo "" >> ${LOG_NAME}
NCPDP_FILE=${ZIP_DIR}/${NCPDP[1]}
REC_CNT=`wc -l ${NCPDP_FILE} | awk '{print $1}'`
echo "Record Count = $REC_CNT" >> ${LOG_NAME}


if [ ${TEST} = 0 ]
then
   cat ${LOG_NAME} | ${MAIL_PROG} -s "Monthly NCPDP Notification" ${MAIL_TO}
fi

cleanup


exit 0
