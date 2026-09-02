#!/bin/ksh
#
# Program Name	: clm_ssrx.sh
# Description	: Prepare claims file for SSRX to pick-up
#               : Command Line Arguments:
#                       -d <mmyy> Date for filename
# Author	: Linda Jefferis
# Date		: 02/16/2001
# Modifications : 02/21/2001 - Changed some variable names  (LSJ)
#		: 02/22/2001 - Now runs addlf to add control characters to end of file  (LSJ)
#		: 10/20/2005 - Changes for Linux commands  (LSJ)
#
# Variables Used:
DATE=`date`
FILE_DATE="null"
FILE_LOC=/usr/lnk/tapes				# Location of original file
NEW_FLOC=/tmp					# Location of zip files
DEST_LOC=raven:/home/ssrx/ssrx-tr  	 	# Location of file for pickup
TAPE_FILE=???CL109SSI				# Original file
ZIP_PROG=/usr/bin/zip
ADDLF_PROG="/usr/local/bin/addlf"
RECSIZE="300"


remove_file()
{  
   cd ${NEW_FLOC}
   if test -f ${FNAME}
   then
     rm -f ${FNAME}
   else
     echo "--*> Can not remove file. ${FNAME} does not exist."
   fi
}

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clm_ssrx.sh [-d <mmdd>]

ENDOFUSAGE
  exit 1
}

set_filenames()
{
   if [ ${FILE_DATE} = "null" ]
   then
      usage
   else
      ZIP_FILE=pdm${FILE_DATE}.zip      # Zip file name
      CLM_FILE=pdm${FILE_DATE}.txt
   fi
}

convert_file()
{
   cd ${FILE_LOC}
   if test -s ${TAPE_FILE}
   then
     ${ADDLF_PROG} ${RECSIZE} ${TAPE_FILE} ${NEW_FLOC}/${CLM_FILE}
   else
     echo "-*> SSRX claims file does not exist..."
   fi

}


zip_files()
{  cd ${NEW_FLOC}

   if test -f ${CLM_FILE}
   then
     ${ZIP_PROG} ${ZIP_FILE} ${CLM_FILE}
   else
     echo "-*> ${NEW_FLOC}/${CLM_FILE} does not exist..."
   fi

}

copy_files()
{  cd ${NEW_FLOC}

   if test -f ${ZIP_FILE}
   then
     rcp ${ZIP_FILE} ${DEST_LOC}
     echo "-=> SSRX file copied..."
   else
     echo "-*> SSRX file not copied to Raven."
   fi
   
}

clean_up()
{  cd ${NEW_FLOC}
   FNAME=${CLM_FILE}
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
echo "--> Renaming files ..."
echo

convert_file

echo
echo "--> Zipping current files..."
echo

zip_files

echo 
echo "--> Copying files to raven..."

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up
 
echo "-=> Finished."

date +%T

exit 0
