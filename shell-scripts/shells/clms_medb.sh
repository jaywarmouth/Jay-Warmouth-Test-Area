#!/bin/sh
#
# Program Name	: clms_medb.sh
# Description	: Prepare bi-weekly (Claims and Invoice) files for MedBen to pick up.
#		: Command Line Arguments:
#			-d <mmyy> P/E Date for filename
# Author	: Linda Jefferis
#
#
# Variables Used:
DATE=`date`
FILE_DATE="null"
FILE_LOC=/usr/lnk/tapes				# Location of original file
TMP_LOC=/tmp					# Location of zip files
INV_LOC="/usr/lnk/xp/sys0049"			# Location Invoice file
INV_FILE="invb"					# Invoice filename prefix

HRMB2_FOUND=0

HRMB2_CLAIMS=???CL111D0-P-HRMB			# Original file
RECSIZE2=500
PROG_DIR="/usr/local/bin"
ZIP_PROG="/usr/bin/zip"
MAIL_TO="MISOPS@medben.com, edanner@medben.com, blpainter@medben.com"
MAIL_CC="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="MEDB"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ftp-hrmb.sh [-d <mmdd>]

ENDOFUSAGE
  exit 1
}

set_filenames()
{
   if [ ${FILE_DATE} = "null" ]
   then
      usage
   else
      H2_CLAIMS=hrmb-427-${FILE_DATE}.txt	# Converted file name
      ZIP_FILE=pdm${FILE_DATE}.zip	# Zip file name
   fi
}

rename_files()
{  cd ${FILE_LOC}

   if test -f ${HRMB2_CLAIMS}
   then
     HRMB2_FOUND=1
     ${PROG_DIR}/addlf ${RECSIZE2} ${HRMB2_CLAIMS} ${TMP_LOC}/${H2_CLAIMS}
   else
     echo "-*> Claim111 HRMB claims file does not exist..."
   fi


}

zip_files()
{ 
     ${ZIP_PROG} -mj ${TMP_LOC}/${ZIP_FILE} ${TMP_LOC}/${H2_CLAIMS}
}

copy_files()
{  
   if test -f ${TMP_LOC}/${ZIP_FILE}
   then
     ${TR_PROG} ${TR_ID} ${TMP_LOC}/${ZIP_FILE} ${INV_LOC}/${INV_FILE}${FILE_DATE}
     if test $? -ne 0
     then
        echo "*-> Transfer of file failed"
	clean_up
	exit 1
     fi
     echo "-=> HRMB files copied..."
     echo "The files, ${ZIP_FILE} and ${INV_FILE}${FILE_DATE}, are now available." | ${MAIL_PROG} -s "MEDBEN BI-WEEKLY FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
   else
     echo "-*> HRMB files not copied."
     clean_up
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
echo "--> Renaming files for archival..."
echo

rename_files

echo
echo "--> Zipping current files..."
echo

zip_files

echo 
echo "--> Copying files..."

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up
 
echo "-=> Finished."

date +%T

exit 0
