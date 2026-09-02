#!/bin/sh
#
# Program Name	: ldmonth-dtms.sh
# Description   : Quarterly Medispan Tape Load 
#		  Command line arguments:
#		  -d <ccyymmdd> - date of each zip file
#
# Variables Used:
TAPE_PATH=/usr/lnk/wt/oper-wt/DTMS
PROD_PATH="/usr/lnk/dtms"
UNZIP_PROG="/usr/bin/unzip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ldmonth-dtms.sh 

ENDOFUSAGE
  exit 1
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

echo "Monthly DTMSV2.1 File Load"
date

ZIP_FILE="dtmsv2.1_0_en_mo_std_2.1.1_d_${DATE}.zip"
TP_FILE="DTMSV2"
FILE="MSDTMAIN"

echo "--> Unzip/Move files"
${UNZIP_PROG} -d ${PROD_PATH} ${TAPE_PATH}/${ZIP_FILE} ${TP_FILE}
mv ${PROD_PATH}/${TP_FILE} ${PROD_PATH}/${FILE}
chmod 664 ${PROD_PATH}/${FILE}
chgrp pdm ${PROD_PATH}/${FILE}

date

exit 0
