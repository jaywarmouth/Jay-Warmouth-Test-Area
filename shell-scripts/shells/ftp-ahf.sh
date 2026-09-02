#!/bin/ksh
#
# Program Name	: ftp-ahf.sh
# Description	: Prepare bi-monthly Invoice files for Aultcare to pick up.
#		: Command Line Arguments:
#			-d <mmyy> P/E Date for filename
# Author	: Linda Jefferis
# Date		: 07/10/2002
# Modifications : 03/27/2003 - Addition of new MEDI file  (LSJ)
#		: 10/20/2005 - Changes for linux  (LSJ)
#		: 11/29/2005 - Changes for new system names  (LSJ)
#               : 02/14/2006 - Change /usr/bin/logname to computers@pdmi.com
#		: 08/17/2006 - Changed INV_FILE to inv-t-<date>  (LSJ)
#		: 08/17/2006 - Removed sys64 logic  (LSJ)
#		: 08/23/2006 - Changes for 4-digit system number  (LSJ)
#		: 11/24/2006 - Added logic back in for sys64  (LSJ)
#               : 02/17/2009 - Changed MAIL_TO and added MAIL_CC  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date`
FILE_DATE="null"
NEW_FLOC=/tmp					# Location of zip files
INV_LOC="/usr/lnk/xp"				# Location Invoice file

AHF_FOUND=0
CAS_FOUND=0
MEDI_FOUND=0

ZIP_PROG="/usr/bin/zip"
MAIL_TO="JNorris@aultcare.com rschrock@aultcare.com Cscarpino2@aultman.com aultcare-is@aultcare.com"
MAIL_CC="operations@pdmi.com"
MAIL_PROG="/bin/mail"
WT_DIR="/usr/lnk/wt"

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
   if test -f ${FNAME}
   then
     rm ${FNAME}
   fi
}

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ftp-ahf.sh [-d <mmdd>]

ENDOFUSAGE
  exit 1
}

set_filenames()
{
   if [ ${FILE_DATE} = "null" ]
   then
      usage
   else
      INV_FILE=inv-t-${FILE_DATE}
      INV_AHF=au-inv${FILE_DATE}.txt	# Converted file name
      INV_CAS=ca-inv${FILE_DATE}.txt	# Converted file name
      INV_MEDI=medi-inv${FILE_DATE}.txt	# Converted file name
      ZIP_FILE=inv${FILE_DATE}.zip	# Zip file name
   fi
}

rename_files()
{ 
   if test -s ${INV_LOC}/sys0048/${INV_FILE}
   then
     AHF_FOUND=1
     cp ${INV_LOC}/sys0048/${INV_FILE} ${NEW_FLOC}/${INV_AHF}
   else
     echo "-*> AHF invoice file does not exist..."
   fi
   if test -s ${INV_LOC}/sys0053/${INV_FILE}
   then
     CAS_FOUND=1
     cp ${INV_LOC}/sys0053/${INV_FILE} ${NEW_FLOC}/${INV_CAS}
   else
     echo "-*> CAS invoice file does not exist..."
   fi
   if test -s ${INV_LOC}/sys0064/${INV_FILE}
   then
     MEDI_FOUND=1
     cp ${INV_LOC}/sys0064/${INV_FILE} ${NEW_FLOC}/${INV_MEDI}
   else
     echo "-*> MEDI invoice file does not exist..."
   fi

}

zip_files()
{  cd ${NEW_FLOC}

   if [ ${AHF_FOUND} = 1 ]
   then
     ${ZIP_PROG} -m ${ZIP_FILE} ${INV_AHF}
   else
     echo "-*> No AHF file to zip"
   fi
   if [ ${CAS_FOUND} = 1 ]
   then
     ${ZIP_PROG} -m ${ZIP_FILE} ${INV_CAS}
   else
     echo "-*> No CAS file to zip"
   fi
   if [ ${MEDI_FOUND} = 1 ]
   then
     ${ZIP_PROG} -m ${ZIP_FILE} ${INV_MEDI}
   else
     echo "-*> No MEDI file to zip"
   fi

}

copy_files()
{  cd ${NEW_FLOC}

   if test -s ${ZIP_FILE}
   then
     cp ${ZIP_FILE} ${DEST_LOC}
     echo "-=> Aultcare files copied..."
     echo "The bi-monthly invoice zip file, ${ZIP_FILE}, is now available." | ${MAIL_PROG} -s "AHF BI-MONTHLY FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
   else
     echo "-*> AHF file not copied to raven."
   fi
   
}

clean_up()
{  
   FNAME=${NEW_FLOC}/${ZIP_FILE}
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

DEST_LOC=${WT_DIR}/ault-wt

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
