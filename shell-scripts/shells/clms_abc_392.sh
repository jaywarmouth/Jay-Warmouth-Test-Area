#!/bin/ksh
#
# Program Name	: clms_abc_392.sh
# Description	: Data file for Fred's and provided to BCBST
#               : Command Line Arguments:
#                       -p <mmddccyy> Date for filename
# Author	: Linda Jefferis
# Date		: 08/31/2010
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date`
FILE_DATE="null"
FILE_LOC=/usr/lnk/tapes			# Location of original file
TAPE_FILE=???CLNCPDP01-P-BCBST
MAIL_TO="glen_olson@bcbst.com"
MAIL_CC="operations@pdmi.com"
MAIL_PROG="/bin/mail"
WT_DIR="/usr/lnk/wt/bcbst-wt"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_abc_392.sh [-p <mmddccyy>]

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
	CLM_FILES=freds_clms_${FILE_DATE}.txt
}

copy_files()
{  
	cp ${FILE_LOC}/${TAPE_FILE} ${WT_DIR}/${CLM_FILES}
	if test $? -eq 0
	then
     		echo "The file for p/e ${FILE_DATE} is now available for downloading." | ${MAIL_PROG} -s "FREDS BI-WEEKLY CLAIMS FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO} 
   	else
     		echo "-*> file not copied."
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


echo 
echo "--> Copying files to ${WT_DIR}..."

copy_files

 
echo "-=> Finished."

exit 0
