#!/bin/ksh
#
# Program Name	: wkclms_spo1384.sh
# Description	: Procedure to upload weekly claim111d0 file to Sisco (1384)
#		  Command Line Arguments:
#                 -d <ccyymmdd> - alternate date for input file; by default uses current date.
# Author	: Dawn M. Engler
# Date		: 01/14/2015
# Modifications : 07/24/2015 - change CLM_FILE variable to new file name provided by Reporting Services. (TT:14023-2, DME)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/wt/oper-wt/week"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="SISCO"
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wkclms_sis.sh 

ENDOFUSAGE
  exit 1
}

# Set File names
set_filenames()
{
	CLM_FILE="TrueRxClaim111DZeroClaimsData_????????.xls"
}
	


#
# Copy files
copy_files()
{
	if test -f ${FILE_LOC}/${CLM_FILE}
	then
	   ${TR_PROG} ${TR_ID} ${FILE_LOC}/${CLM_FILE}
	   if test $? -ne 0
	     then
		echo "*-> Transfer of file failed"
		exit 1
	   fi
	else
	   echo "--*> File, ${FILE_LOC}/${CLM_FILE}, was not found..."
	fi
}

#
# Cleanup
clean_up()
{
	rm ${FILE_LOC}/${CLM_FILE}
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
echo "--> Copying file ..."
echo

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0

