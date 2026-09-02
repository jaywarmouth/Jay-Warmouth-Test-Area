#!/bin/ksh
#
# Program Name	: dailyclms_tscnaa.sh
# Description	: Procedure to upload daily claims file for Truescripts-NAA (163)
#		  Command Line Arguments:
#                 -d <ccyymmdd> - alternate date for input file; by default uses current date.
# Author	: Linda S. Jefferis
# Date		: 01/02/2015
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/wt/oper-wt/claimsdetail/TSCNAA"
TMP_LOC="/tmp"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="TSCNAA"
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dailyclms_tscnaa.sh 

ENDOFUSAGE
  exit 1
}

# Set File names
set_filenames()
{
	CLM_FILE="Dailyclms-TSCNAA-${DATE}.txt"
	INPUT_FILE="TSCSponsor3155LoganClaimsData_${DATE}.txt"
}
	

#
rename_files()
{
	if test -s ${FILE_LOC}/${INPUT_FILE}
	then
		cp ${FILE_LOC}/${INPUT_FILE} ${TMP_LOC}/${CLM_FILE} 
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}

#
# Copy files
copy_files()
{
	if test -f ${TMP_LOC}/${CLM_FILE}
	then
	   ${TR_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE}
	   if test $? -ne 0
	     then
		echo "*-> Transfer of file failed"
		exit 1
	   fi
	else
	   echo "--*> File, ${TMP_LOC}/${CLM_FILE}, was not found..."
	fi
}

#
# Cleanup
clean_up()
{
	rm ${FILE_LOC}/${INPUT_FILE}
	rm ${TMP_LOC}/${CLM_FILE}
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

echo
echo "--> Renaming files for archival..."
echo

rename_files

echo 
echo "--> Copying file ..."
echo

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
