#!/bin/sh
#
# Program Name	: tr-urx-files.sh
# Description	: Script for providing off-cycle files to URX
#		  Command Line:
#		  -r <yyyymmdd> - optional report date 
#			Default is current date
#		  -f <FILE_DIR> - optional directory for input "URX-" files
#			Default is /usr/lnk/shares/ftp-tmp
# Author	: Linda S. Jefferis
# Date		: 03/21/2007
# Modifications : 04/05/2007 - Changed sessor email to cameron  (LSJ)
#		: 05/15/2007 - Addition of FILE_3 and NEW_FILE_3  (LSJ)
#		: 06/14/2007 - Addition of FILE_4 and NEW_FILE_4  (LSJ)
#		: 08/06/2008 - Added new email for MAIL_TO  (LSJ)
#		: 03/31/2010 - Changed fax of URX-MKTNV to email of created PDF of this report.
#		: 04/03/2012 - Added PSP to DEST_LOC asp per request from URX
#		: 07/11/2013 - Replaced boston with hoprich emails for MAIL_TO (DME)
#		: 09/19/2013 - Replaced hoprich with morgan emails for MAIL_TO (DME)
#		: 11/1/2016 - Added "-r" and "-f" options.
#		: 06/29/2017 - TT16705-31; add urx-08 to distribution.
#		: 11/22/2019 - TT19357-87; stop distribution to urx-wt
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
FILE_DIR="/usr/lnk/shares/ftp-tmp"
MAIL_PROG="/usr/bin/mutt"
#MAIL_TO="Accounting@universalrx.com Tomlinson@universalrx.com Morgan@universalrx.com operations@pdmi.com"
MAIL_TO_ACCT="finance@pdmi.com"
INV_FILE="URX-MKTINV"
DATE=`date +%Y%m%d`
FILE_1="URX-ADJMKTDET.csv"
FILE_2="URX-MKT.csv"
FILE_3="URX-ADJMKTSUM.csv"
FILE_4="URX-MKTDET.csv"
NEW_FILE_1="PSP_Clms_without_Diff_Coll_Detail"
NEW_FILE_2="PSP_Sumry_Clms_with_Diff_Coll"
NEW_FILE_3="PSP_Clms_without_Diff_Coll_Summary"
NEW_FILE_4="PSP_Detail_Clms_with_Diff_Coll"
WT_DIR="/usr/lnk/wt"
RERUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tr-urx-files.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	DATE=$1
	RERUN=1
	;;
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FILE_DIR=$1
	;;
  esac
  shift
done


# Parse environment variables
parse_env

DEST_LOC="${WT_DIR}/finance"
#DEST_LOC="${WT_DIR}/urx-08/PSP"

if [ $RERUN = 0 ]
then
	enscript -RBj -o - ${FILE_DIR}/${INV_FILE} | ps2pdf - ${FILE_DIR}/${INV_FILE}.pdf
	echo "URX Marketing Fee Invoice attached and PSP reports uploaded to finance WT location" | ${MAIL_PROG} -a ${FILE_DIR}/${INV_FILE}.pdf -s "URX Deduction Information" ${MAIL_TO_ACCT}
fi
cp ${FILE_DIR}/${FILE_1} ${DEST_LOC}/${NEW_FILE_1}_${DATE}.csv
cp ${FILE_DIR}/${FILE_2} ${DEST_LOC}/${NEW_FILE_2}_${DATE}.csv
cp ${FILE_DIR}/${FILE_3} ${DEST_LOC}/${NEW_FILE_3}_${DATE}.csv
cp ${FILE_DIR}/${FILE_4} ${DEST_LOC}/${NEW_FILE_4}_${DATE}.csv
#if [ $RERUN = 0 ]
#then
#	echo "The Marketing Fee Invoice is attached and new PSP files have been uploaded to the urx-wt area" | ${MAIL_PROG} -a ${FILE_DIR}/${INV_FILE}.pdf -s "FILE NOTIFICATION" ${MAIL_TO}
#fi

exit 0
