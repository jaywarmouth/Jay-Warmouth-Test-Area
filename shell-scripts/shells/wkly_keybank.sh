#!/bin/ksh
#
# Program Name	: wkly_keybank.sh
# Description	: Setup of file for transferring to KeyBank
#		  Command Line Arguments:
#		  -d <paid date-yymmdd>
# Author	: Linda S. Jefferis
# Date		: 11/11/1999
# Modifications : 06/13/2002 - Modifications for email report  (LSJ) 
#		: 09/12/2003 - Removed logic for FILE_HDR  (LSJ)
#		: 09/12/2003 - Added logic for rcp for new transfer procedure via Web  (LSJ)
#		: 01/06/2005 - Added logic for twice cycle files  (LSJ)
#		: 06/28/2005 - Added cycle name to totals report name  (LSJ)
#		: 10/24/2005 - Changes for Linux  (LSJ)
#		: 12/03/2005 - Changes for new system names  (LSJ)
#		: 12/19/2005 - Changed MAIL_TO to computers@pdmi.com  (LSJ)
#		: 10/26/2006 - Removed emailing of totals  (LSJ)
#		: 09/18/2009 - Changes for switch to new check run process
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_DIR="/usr/lnk/tapes"
FILENAME="SOCIE00INP"
OUTPUT_DIR="/usr/lnk/keybank"
REMOTE_DIR=/usr/lnk/shares/ftp-tmp
RPT_PREFIX="totals-"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wkly_keybank.sh -d <check date> 
	check date: format is yymmdd		required

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# Rename ,scp file, and archive file
prepare_file()
{
   if test -s ${FILE_DIR}/${FILENAME}
   then
	cp ${FILE_DIR}/${FILENAME} ${REMOTE_DIR}/${DATE}.key
	cp ${FILE_DIR}/${FILENAME} ${OUTPUT_DIR}/${DATE}.key
   else
	echo ""
	echo "-*> Procedures in Flexgen need run first to create ${FILE_DIR}/${FILENAME}"
	exit 1
   fi
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
  esac
  shift
done


# Parse environment variables
#parse_env

prepare_file


exit 0
