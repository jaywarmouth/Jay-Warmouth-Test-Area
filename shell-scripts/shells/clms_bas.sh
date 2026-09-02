#!/bin/ksh
#
# Program Name	: clms_bas.sh
# Description	: Prepare data file for BAS
#               : Command Line Arguments:
#                       -p <mmddccyy> Date for filename
# Author	: Linda Jefferis
# Date		: 03/19/2009
# Modifications : 08/26/2009 - Changed logic for multiple files and new file directory
#		: 04/19/2011 - Added edi email as requested.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date`
FILE_DATE="null"
FILE_LOC=/usr/lnk/tapes/BAS			# Location of original file
MAIL_TO="alicej@benadmsys.com edi@benadmsys.com"
MAIL_CC="operations@pdmi.com"
ZIP_PROG="/usr/bin/zip"
MAIL_PROG="/bin/mail"
WT_DIR="/usr/lnk/wt"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_bas.sh [-p <mmddccyy>]

ENDOFUSAGE
  exit 1
}

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


set_filenames()
{
	CLM_FILES=clms_*_${FILE_DATE}.txt
	TEXT_FILES=text_*_${FILE_DATE}.txt
}

copy_files()
{  
	cp ${FILE_LOC}/${TEXT_FILES} ${DEST_LOC}
	cp ${FILE_LOC}/${CLM_FILES} ${DEST_LOC}
	if test $? -eq 0
	then
     		echo "The files for p/e ${FILE_DATE} are now available for downloading." | ${MAIL_PROG} -s "BAS BI-WEEKLY CLAIMS FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO} 
   	else
     		echo "-*> BAS files not copied."
   	fi
   
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
	set_filenames
        ;;
  esac
  shift
done

parse_env

DEST_LOC=${WT_DIR}/bead-04

echo 
echo "--> Copying files to ${DEST_LOC}..."

copy_files

 
echo "-=> Finished."

exit 0
