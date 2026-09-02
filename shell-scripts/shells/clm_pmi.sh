#!/bin/ksh
#
# Program Name	: clm_pmi.sh
# Description	: Prepare files for PMI to pickup
#               : Command Line Arguments:
#                       -d <mmyy> Date for filename
# Author	: Linda Jefferis
# Date		: 02/21/2001
# Modifications : 04/02/2001 - Changed CL111 to CL119  (LSJ)
#		: 04/02/2001 - Added PMITEXT  (LSJ)
#		: 10/20/2005 - Changes for Linux commands  (LSJ)
#
# Variables Used:
DATE=`date`
FILE_DATE="null"
FILE_LOC=/usr/lnk/tapes				# Location of original file
NEW_FLOC=/tmp					# Location of zip files
DEST_LOC=rook:/home/pmi/pmi-ftp/transfer 	# Location of file for pickup
TAPE_FILE=???CL119PMI				# Original file
LOG_FILE=???PMITEXT				# Original log text file
ZIP_PROG="/usr/bin/zip"


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

usage: clm_pmi.sh [-d <mmdd>]

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
     ${ZIP_PROG} ${ZIP_FILE} ${CLM_FILE} ${NEW_LOG}
   fi

}

copy_files()
{  cd ${NEW_FLOC}

   if test -f ${ZIP_FILE}
   then
     scp ${ZIP_FILE} ${DEST_LOC}
     echo "-=> PMI file copied..."
   else
     echo "-*> PMI file not copied to Raven."
   fi
   
}

clean_up()
{  cd ${NEW_FLOC}
   FNAME=${CLM_FILE}
   remove_file
   FNAME=${NEW_LOG}
   remove_file
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
