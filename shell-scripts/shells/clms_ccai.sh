#!/bin/ksh
#
# Program Name	: clms_ccai.sh
# Description	: Prepare files for transfer to CCAI
#               : Command Line Arguments:
#                       -p <mmddccyy> Date for filename
# Author	: Linda Jefferis
# Date		: 01/14/2008
# Modifications : 01/29/2008 - Added "exit 1" if test of TAPE_FILE is false  (LSJ)
#		: 02/24/2009 - Changed email procedure  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date`
FILE_DATE="null"
FILE_LOC=/usr/lnk/tapes				# Location of original file
NEW_FLOC=/tmp					# Location of zip files
TAPE_FILE=???CL117-P-CCAI			# Original file
MAIL_TO="abdulb@ccarei.com"
MAIL_CC="operations@pdmi.com"
ZIP_PROG="/usr/bin/zip"
MAIL_PROG="/bin/mail"
WT_DIR="/usr/lnk/wt"


#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
        IFS=${EQUAL}
        set $VAR
        NVAR=$1
        export ${NVAR}
        if [ $? -ne 0 ]
        then
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

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

usage: clms_ccai.sh [-p <mmddccyy>]

ENDOFUSAGE
  exit 1
}

set_filenames()
{
   DEST_LOC=${WT_DIR}/ccai-wt
   if [ ${FILE_DATE} = "null" ]
   then
      usage
   else
      ZIP_FILE=clms_ccai${FILE_DATE}.zip      # Zip file name
      CLM_FILE=clms_ccai${FILE_DATE}.txt
   fi
}

rename_files()
{
   cd ${FILE_LOC}
   if test -s ${TAPE_FILE}
   then
     cp ${TAPE_FILE} ${NEW_FLOC}/${CLM_FILE}
   else
     echo "-*> CCPI claims file does not exist..."
     exit 1
   fi

}


zip_files()
{  cd ${NEW_FLOC}

   if test -f ${CLM_FILE}
   then
     ${ZIP_PROG} -m ${ZIP_FILE} ${CLM_FILE}
   fi

}

copy_files()
{  cd ${NEW_FLOC}

   if test -f ${ZIP_FILE}
   then
     cp ${ZIP_FILE} ${DEST_LOC}
     echo "-=> CCAI file copied..."
     echo "The file, ${ZIP_FILE}, is now available." | ${MAIL_PROG} -s "CCAI BI-WEEKLY CLAIMS FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO} 
   else
     echo "-*> CCAI file not copied."
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
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_DATE=$1
        ;;
  esac
  shift
done

parse_env

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
echo "--> Copying files to ${DEST_LOC}..."

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up
 
echo "-=> Finished."

date +%T

exit 0
