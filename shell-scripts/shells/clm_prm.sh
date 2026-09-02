#!/bin/ksh
#
# Program Name	: clm_prm.sh
# Description	: Prepare claims and invoice file for PRM
#               : Command Line Arguments:
#                       -d <mmyy> Date for filename
# Author	: Linda Jefferis
# Date		: 10/16/2000
# Modifications : 02/16/2001 - Added ZIP_PROG variable  (LSJ)
#		: 02/21/2001 - Changed some variable names  (LSJ)
#		: 03/05/2002 - Added invoice file to zip file and changed DEST_LOC  (LSJ)
#		: 10/29/2002 - New Web DEST_LOC  (LSJ)
#		: 12/03/2002 - Changed DEST_LOC  (LSJ)
#		: 10/20/2005 - Changes for linux commands  (LSJ)
#		: 11/27/2005 - Changed system name(s)  (LSJ)
#		: 02/14/2006 - Change /usr/bin/logname to computers@pdmi.com
#		: 08/17/2006 - Added logic for inv-p filename  (LSJ)
#		: 05/07/2007 - Removed RECSIZE variable, not needed  (LSJ)
#		: 05/29/2007 - Removed logic for DES file  (LSJ)
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
TAPE_FILE=???CL111-P-PRM			# Original file
LOG_FILE=???-P-PRMTEXT			# Summary of totals file
NEW_LOG=readme.txt				# Log file 
INV_LOC="/usr/lnk/xp/sys0001"
MAIL_TO=tkear@primenet-networks.com
MAIL_CC=operations@pdmi.com
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
     rm -f ${FNAME}
   else
     echo "--*> Can not remove file. ${FNAME} does not exist."
   fi
}

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clm_prm.sh [-d <mmdd>]

ENDOFUSAGE
  exit 1
}

set_filenames()
{
   DEST_LOC=${WT_DIR}/pnet-wt
   if [ ${FILE_DATE} = "null" ]
   then
      usage
   else
      ZIP_FILE=pdm${FILE_DATE}.zip      # Zip file name
      CLM_FILE=pdm${FILE_DATE}.txt	# New File name
      INV_FILE=inv-p-${FILE_DATE}	# New invoice name
      NEW_INV_FILE=inv-${FILE_DATE}
   fi
}

rename_files()
{
   if test -s ${FILE_LOC}/${TAPE_FILE}
   then
     cp ${FILE_LOC}/${TAPE_FILE} ${NEW_FLOC}/${CLM_FILE}
     cp ${FILE_LOC}/${LOG_FILE} ${NEW_FLOC}/${NEW_LOG}
   else
     echo ""
     echo "-*> PRM claims file does not exist..."
   fi

   if test -s ${INV_LOC}/${INV_FILE}
   then
     cp ${INV_LOC}/${INV_FILE} ${NEW_FLOC}/${NEW_INV_FILE}
   else
     echo ""
     echo "-*> PRM ${INV_FILE} does not exist..."
   fi
}


zip_files()
{  cd ${NEW_FLOC}

   if test -f ${CLM_FILE}
   then
     ${ZIP_PROG} ${ZIP_FILE} ${CLM_FILE} ${NEW_LOG}
   fi
   
   if test -f ${NEW_INV_FILE}
   then
     ${ZIP_PROG} ${ZIP_FILE} ${NEW_INV_FILE}
   fi

}

copy_files()
{  cd ${NEW_FLOC}

   if test -f ${ZIP_FILE}
   then
     cp ${ZIP_FILE} ${DEST_LOC}
     echo "The bi-weekly zip file, ${ZIP_FILE}, is now available on the Web Server for downloading. Please delete the file once it has been downloaded." | ${MAIL_PROG} -s "PRM BI_WEEKLY FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
     echo "-=> PRM file copied..."
   else
     echo "-*> PRM file not copied."
   fi
   
}

clean_up()
{  cd ${NEW_FLOC}
   FNAME=${CLM_FILE}
   remove_file
   FNAME=${NEW_LOG}
   remove_file
   FNAME=${NEW_INV_FILE}
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

parse_env

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
