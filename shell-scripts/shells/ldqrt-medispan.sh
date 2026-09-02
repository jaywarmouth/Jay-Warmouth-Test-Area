#!/bin/sh
#
# Program Name	: ldqrt-medispan.sh
# Description   : Quarterly Medispan Tape Load 
#		  Command line arguments:
#		  -g <dup> - group of files to load
#			dup - Duplicate Therapy
#		  -d <ccyymmdd> - date of each zip file
# Author	: Linda S. Jefferis
# Date		: 04/02/99
# Modifications : 07/15/99 - Changed procedure for dtms  (LSJ)
#		: 12/02/99 - Removed char_repl procedure  (LSJ)
#		: 05/06/04 - Added "dt" to procedures that copy files to Raven  (LSJ)
#		: 11/30/2005 - Changes for new system names  (LSJ)
#		: 02/03/2006 - Changed script to not use /opt/cdrom and mounting of CD, instead reads files from husk  (LSJ)
#		: 06/30/2008 - Added logic for unzip of files sent via FTP instead of CD  (LSJ)
#		: 01/21/2011 - Added "-d" option and copy directly from mspan-ftp area
#		: 07/14/2014 - Change cp TAPE_PATH to mv TAPE_PATH in get_files
#
# Variables Used:
PROD_SYS="prod10"
TAPE_PATH=/usr/lnk/wt/oper-wt/DUPTHER
LOG="/tmp/qrt_log"
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
# Validate -g options
validate_grp()
{
	case ${GROUP} in
	  "dtms" | "dds" | "dup" | "dck")
	  	;;
	  *) usage
		;;
	esac
}

#
# Set Variables
set_variables()
{
	case ${GROUP} in
	  "dtms")
		LOAD_PATH="/usr/upd/dtms"
		ZIP_FILE="dtmsv2.1_0_0_qj_std_2.1_d_${DATE}.zip"
		TP_FILE[1]="DTMSV2"
		FILE[1]="MSDTMAIN"
		i=1
		MAXVALUE=1
		;;
	  "dds")
		LOAD_PATH="/usr/upd/drug_dis"
		ZIP_FILE="drug-dis_0_0_qj_standard_1.0_d_${DATE}.zip"
		PROD_PATH="/usr/upd/drug_dis"
		TP_FILE[1]="DISEASE"
		TP_FILE[2]="DRUGDIAG"
		TP_FILE[3]="DRUGDIS"
		TP_FILE[4]="MESSAGE"
		TP_FILE[5]="ICD9CM"
		TP_FILE[6]="ICD9XREF"
		FILE[1]="MSDDA"
		FILE[2]="MSDDB"
		FILE[3]="MSDDC"
		FILE[4]="MSDDD"
		FILE[5]="MSDDE"
		FILE[6]="MSDDF"
		i=1
		MAXVALUE=6
		;;
	  "dck")
		LOAD_PATH="/usr/upd/dosecheck"
		ZIP_FILE="dose-chek_0_0_qj_standard_1.0_d_${DATE}.zip"
		PROD_PATH="/usr/upd/dosecheck"
		TP_FILE[1]="DCGPI"
		TP_FILE[2]="DCSIG"
		TP_FILE[3]="DCGPICOM"
		TP_FILE[4]="DCCOM"
		FILE[1]="MSDCA"
		FILE[2]="MSDCB"
		FILE[3]="MSDCC"
		FILE[4]="MSDCD"
		i=1
		MAXVALUE=4
		;;
	  "dup")
		LOAD_PATH="/usr/upd/dt"
		ZIP_FILE="dupe-ther_0_0_qj_standard_1.0_d_${DATE}.zip"
		PROD_PATH="/usr/upd/dt"
		TP_FILE[1]="DTGPI"
		TP_FILE[2]="DTCLASS"
		TP_FILE[3]="DTVAL"
		FILE[1]="MSDTA"
		FILE[2]="MSDTB"
		FILE[3]="MSDTC"
		i=1
		MAXVALUE=3
		;;
	esac
}
	


#
# Load files from mspan-ftp
get_files()
{
	echo "--> Moving files"
	while [ $i -le $MAXVALUE ]
	do
	  ${UNZIP_PROG} -d ${TAPE_PATH} ${TAPE_PATH}/${ZIP_FILE} ${TP_FILE[i]}
	  mv ${TAPE_PATH}/${TP_FILE[i]} ${LOAD_PATH}/${FILE[i]}
	  chmod 664 ${LOAD_PATH}/${FILE[i]} 
	  chgrp pdm ${LOAD_PATH}/${FILE[i]} 
	  let i=i+1
	done
}

#
# Put files on production machine
put_files()
{
	echo "--> Putting files to "${PROD_SYS}
	while [ $i -le ${MAXVALUE} ]
	do	
	  scp ${LOAD_PATH}/${FILE[i]} ${PROD_SYS}:${PROD_PATH}
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
    -g) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	GROUP=$1
	validate_grp
	;;
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

echo "Quarterly Medispan File Load"
date

set_variables

get_files

case ${GROUP} in
  "dds")
	i=1
	MAXVALUE=6
	put_files
	;;
  "dck")
	i=1
	MAXVALUE=1
	put_files
	;;
  "dup")
	i=1
	MAXVALUE=3
	put_files
	;;
esac

date

exit 0
