#!/bin/ksh
#
# Program Name	: clms_LBRXhealthsmart.sh
# Description	: Procedure to setup claims file for TrueScripts-Meritain sponsors 
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 08/05/2014
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL111D0-X-MERI"
LOG_FILE="???CL111D0-WxMERITEXT"
ZIP_PROG="/usr/bin/zip"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="500"
MAIL_PROG="/bin/mail"
MAIL_TO="Jenny.Koskiewicz@healthsmart.com"
MAIL_CC="operations@pdmi.com"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="HSBS"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_LBRXhealthsmart.sh -p <p/e date>
	<p/e date> is period ending date in mmddccyy format  (required)

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

# Convert input date
conv_date()
{
        MO=`echo ${IN_DATE} | cut -c1-2`
        DAY=`echo ${IN_DATE} | cut -c3-4`
        YR=`echo ${IN_DATE} | cut -c5-8`
        PE_DATE=${YR}${MO}${DAY}
}


# Set File names
set_filenames()
{
	CLM_FILE="Refreshclms-LBRXHealthsmart-${PE_DATE}.txt"

}
	

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_LEN} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}

#
# Copy files
copy_files()
{
	if test -f ${TMP_LOC}/${CLM_FILE}
	then
	   ${TR_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE}
	   if test $? -ne 0
	     then
		echo "*-> Transfer of file failed"
		clean_up
		exit 1
	   fi
	   cat ${FILE_LOC}/${LOG_FILE} | ${MAIL_PROG} -s "Healthsmart - Refresh Claims File Notification" -c ${MAIL_CC} ${MAIL_TO}
	else
	   echo "--*> File not copied..."
	fi
}

#
# Cleanup
clean_up()
{
	rm ${TMP_LOC}/${CLM_FILE}
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	IN_DATE=$1
	conv_date
	;;
  esac
  shift
done

# Parse environment variables
parse_env

set_filenames

echo
echo "--> Renaming files for archival..."
echo

rename_files

echo 
echo "--> Copying file ..."
echo

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
