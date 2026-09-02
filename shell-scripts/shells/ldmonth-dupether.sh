#!/bin/sh
#
# Program Name	: ldmonth-dupether.sh
# Description   : Monthly Medispan Tape Load 
#		  Command line arguments:
#		  -d <ccyymmdd> - date of each zip file
#
# Variables Used:
TAPE_PATH=/usr/lnk/wt/oper-wt/DUPTHER
UNZIP_PROG="/usr/bin/unzip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ldqrt-medispan.sh 

ENDOFUSAGE
  exit 1
}


#
# Set Variables
set_variables()
{
		LOAD_PATH="/usr/upd/dt"
		ZIP_FILE="dupe-ther_0_0_mo_standard_1.0_d_${DATE}.zip"
		PROD_PATH="/usr/upd/dt"
		TP_FILE[1]="DTGPI"
		TP_FILE[2]="DTCLASS"
		TP_FILE[3]="DTVAL"
		FILE[1]="MSDTA"
		FILE[2]="MSDTB"
		FILE[3]="MSDTC"
		MAXVALUE=3
}
	


#
# Unzip/Move Files
get_files()
{
	i=1
	echo "--> Moving files"
	while [ $i -le $MAXVALUE ]
	do
	  ${UNZIP_PROG} -d ${TAPE_PATH} ${TAPE_PATH}/${ZIP_FILE} ${TP_FILE[i]}
	  mv ${TAPE_PATH}/${TP_FILE[i]} ${PROD_PATH}/${FILE[i]}
	  chmod 664 ${PROD_PATH}/${FILE[i]} 
	  chgrp pdm ${PROD_PATH}/${FILE[i]} 
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
        DATE=$1
        ;;
  esac
  shift
done

date

set_variables

get_files

date

exit 0
