#!/bin/ksh
#
# Program Name	: rxeob_tweek_clms.sh
# Description	: Prepare claims file for FTP to RXEOB
#               : Command Line Arguments:
#                       -d <mmdd> Date for filename
# Author	: Linda Jefferis
# Date		: 10/29/2010


#
# Variables Used:
DATE=`date`
FILE_DATE="null"
FILE_LOC=/usr/lnk/tapes				# Location of original file
NEW_FLOC=/tmp					# Location of zip files
DEST_LOC=/usr/lnk/shares/rxeob  	 	# Location of file for pickup
TAPE_FILE=???CL111RX-X-RXEOB			# Original file
LOG_FILE=???-X-RXEOBTEXT			# Summary of totals file
NEW_LOG=readme.txt				# Log file 
ZIP_PROG="/usr/bin/zip"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="RXEOB"


remove_file()
{  
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

usage: rxeob_tweek_clms.sh [-d <mmdd>]
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
      ZIP_FILE=tweek_${FILE_DATE}.zip      # Zip file name
      CLM_FILE=tweek_${FILE_DATE}.txt	# New File name
   fi
}

rename_files()
{
   cd ${FILE_LOC}
   if test -s ${TAPE_FILE}
   then
     cp ${TAPE_FILE} ${NEW_FLOC}/${CLM_FILE}
   else
     echo "-*> RXEOB claims file does not exist..."
   fi

}


zip_files()
{  
   if test -f ${NEW_FLOC}/${CLM_FILE}
   then
     ${ZIP_PROG} -mj ${DEST_LOC}/${ZIP_FILE} ${NEW_FLOC}/${CLM_FILE}
     ${TR_PROG} ${TR_ID} ${DEST_LOC}/${ZIP_FILE}
     if test $? -ne 0
           then
                echo "*-> Transfer of file failed"
                clean_up 
                exit 1
           fi
   else
     echo "-*> ${NEW_FLOC}/${CLM_FILE} does not exist..."
     echo "-*> Exiting script"
     exit 1
   fi

}


clean_up()
{  
	FNAME=${DEST_LOC}/${ZIP_FILE}
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

rename_files

echo
echo "--> Zipping current files..."
echo

zip_files

clean_up

echo "-=> Finished."

date +%T

exit 0
