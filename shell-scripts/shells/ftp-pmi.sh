#!/bin/ksh
#
# Program Name	: ftp-pmi.sh
# Description	: Prepare files for PMI to pickup
#               : Command Line Arguments:
#                       -d <mmyy> Date for filename
# Author	: Linda Jefferis
# Date		: 02/21/2001
# Modifications : 04/02/2001 - Changed CL111 to CL119  (LSJ)
#		: 04/02/2001 - Added PMITEXT  (LSJ)
#		: 04/30/2001 - Added email logic  (LSJ)
#		: 04/30/2001 - Added copy of inv<date> (LSJ)
#		: 07/25/2005 - Changes for week-cycle files  (LSJ)
#		: 10/20/2005 - Changes for linux  (LSJ)
#		: 11/30/2005 - Changes for new system names  (LSJ)
#		: 12/19/2005 - Changed DEST_LOC  (LSJ)
#               : 02/14/2006 - Change /usr/bin/logname to computers@pdmi.com
#		: 08/23/2006 - Changes for 4-digit system number  (LSJ)
#		: 05/25/2007 - Added secure_transfer.sh logic  (LSJ)
#		: 03/02/2009 - Changed email logic  (LSJ)
#
# Variables Used:
DATE=`date`
FILE_DATE="null"
FILE_LOC=/usr/lnk/tapes				# Location of original file
NEW_FLOC=/tmp					# Location of zip files
TAPE_FILE=???CL119-W-PMI			# Original file
LOG_FILE=???CL119-W-PMITEXT			# Original log text file
ZIP_PROG="/usr/bin/zip"
MAIL_PROG="/bin/mail"
MAIL_TO="medsbilling@progressive-medical.com"
MAIL_CC="operations@pdmi.com"
INV_DIR="/usr/lnk/xp/sys0054"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="PMI"


remove_file()
{  
   cd ${NEW_FLOC}
   if test -f ${FNAME}
   then
     rm ${FNAME}
   fi
}

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ftp-pmi.sh [-d <mmdd>]

ENDOFUSAGE
  exit 1
}

set_filenames()
{
   if [ ${FILE_DATE} = "null" ]
   then
      usage
   else
      ZIP_FILE=pmi${FILE_DATE}.zip      # Zip file name
      CLM_FILE=pmi${FILE_DATE}.txt
      NEW_LOG=readme${FILE_DATE}.txt
      INV_FILE="${INV_DIR}/inv${FILE_DATE}"
   fi
}

rename_files()
{
   cd ${FILE_LOC}
   if test -s ${TAPE_FILE}
   then
     cp ${TAPE_FILE} ${NEW_FLOC}/${CLM_FILE}
     cp ${LOG_FILE} ${NEW_FLOC}/${NEW_LOG}
   else
     echo "-*> PMI claims file does not exist..."
   fi

}


zip_files()
{  cd ${NEW_FLOC}

   if test -f ${CLM_FILE}
   then
     ${ZIP_PROG} -m ${ZIP_FILE} ${CLM_FILE} ${NEW_LOG}
   fi

}

copy_files()
{  cd ${NEW_FLOC}

   if test -f ${ZIP_FILE}
   then
     ${TR_PROG} ${TR_ID} ${ZIP_FILE} ${INV_FILE}
     if test $? -ne 0
     then
	echo "*-> Transfer of file failed"
        clean_up
        exit 1
     fi
     echo "-=> PMI file copied..."
     echo "The Weekly Claims file and Invoice file are now available." | ${MAIL_PROG} -s "PMI WEEKLY FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
   else
     echo "-*> PMI file not copied."
     clean_up
     exit 1
   fi
   
}

clean_up()
{  cd ${NEW_FLOC}
   FNAME=${ZIP_FILE}
   remove_file
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
