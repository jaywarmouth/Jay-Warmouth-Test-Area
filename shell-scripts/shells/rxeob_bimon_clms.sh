#!/bin/sh
#
# Program Name	: rxeob_bimon_clms.sh
# Description	: Prepare claims file for FTP to RXEOB
#               : Command Line Arguments:
#                       -d <mmdd> Date for filename
# Author	: Linda Jefferis
# Date		: 11/29/2001
# Modifications : 10/28/2005 - Changes for Linux  (LSJ)
#		: 06/04/2007 - Added secure_transfer.sh logic  (LSJ)
#		: 12/28/2007 - Changed name of TAPE_FILE for new claim111rx procedure  (LSJ)
#		: 07/02/2010 - Added "?" to RXEOB file names  (LSJ)
#
# Variables Used:
FILE_DATE="null"
FILE_LOC=/usr/lnk/tapes				# Location of original file
TMP_LOC=/tmp					# Location of zip files
TAPE_FILE=???CL111RX-T-RXEOB			# Original file
ZIP_PROG="/usr/bin/zip"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="RXEOB-GA"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rxeob_bimon_clms.sh [-d <mmdd>]
	mmdd - current date

ENDOFUSAGE
  exit 1
}

set_filenames()
{
   if [ ${FILE_DATE} = "null" ]
   then
      usage
   else
      ZIP_FILE=bimon_${FILE_DATE}.zip      # Zip file name
      CLM_FILE=bimon_${FILE_DATE}.txt	# New File name
   fi
}

rename_files()
{
   cd ${FILE_LOC}
   if test -s ${TAPE_FILE}
   then
     cp ${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
   else
     echo "-*> RXEOB claims file does not exist..."
   fi

}


zip_files()
{  
   if test -f ${TMP_LOC}/${CLM_FILE}
   then
     ${ZIP_PROG} -mj ${TMP_LOC}/${ZIP_FILE} ${TMP_LOC}/${CLM_FILE}
     ${TR_PROG} ${TR_ID} ${TMP_LOC}/${ZIP_FILE}
     if test $? -ne 0
           then
                echo "*-> Transfer of file failed"
                clean_up
                exit 1
           fi
   else
     echo "-*> ${TMP_LOC}/${CLM_FILE} does not exist..."
     echo "-*> Exiting script"
     exit 1
   fi

}


clean_up()
{  
   rm -f ${TMP_LOC}/${ZIP_FILE}
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
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

date +%T

echo 
echo "--> Renaming files ..."
echo

rename_files

echo
echo "--> Zipping current files..."
echo

zip_files

clean_up

echo "-=> Finished."

date +%T

exit 0
