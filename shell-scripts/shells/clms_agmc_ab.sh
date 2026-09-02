#!/bin/sh
#
# Program Name	: clms_agmc_ab.sh
# Description	: Procedure to setup claims file for AGMC/Advisory Board (sys0052)
#		  Command Line Arguments:
#		  -p <mmccyy>  
# Author	: Linda S. Jefferis
# Date		: 04/06/2010
# Modifications : 06/06/2012 - Changes for manual WINScp upload
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
#TMP_LOC="/tmp"
TMP_LOC="/usr/lnk/shares/ftp-tmp"
TAPE_FILE="???CL109AGMC-M-AGAB"
TEXT_FILE="???AGABTEXT"
#TRANSFER_PROG="/usr/lnk/shell/secure_transfer.sh"
#TR_ID="ADVS"
PE_DATE="null"
MAIL_PROG="/bin/mail"
#MAIL_TO="arthurl@advisory.com khans@advisory.com oliveram@advisory.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_agmc_ab.sh -p <p/e date>
	<p/e date> is period ending date in mmccyy format  (required)

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

# Set Dates
conv_date()
{
	FILE_DATE=`date +%m%d%Y`
	MON=`echo ${PE_DATE} | cut -c1-2`
        YEAR=`echo ${PE_DATE} | cut -c3-6`
}

#
# Set filenames
set_filenames()
{
	CLM_FILE="AkronGeneral_rxclaims_${FILE_DATE}"
	CTRL_FILE="AkronGeneral_control_${FILE_DATE}"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  cp ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	  cp ${FILE_LOC}/${TEXT_FILE} ${TMP_LOC}/${CTRL_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
	echo "The monthly files for ${MON}/${YEAR} are now available." | ${MAIL_PROG} -s "The Advisory Board - Akron General Monthly File Notification" ${MAIL_CC} 
}


# Cleanup
clean_up()
{
	rm ${TMP_LOC}/${CLM_FILE}
	rm ${TMP_LOC}/${CTRL_FILE}
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
	PE_DATE=$1
	conv_date
	set_filenames
	;;
  esac
  shift
done

# Parse environment variables
#parse_env

if [ $PE_DATE = "null" ]
then
	usage
	exit 1
fi

echo
echo "--> Rename files..."
echo

rename_files

echo "AkronGeneral files in /usr/lnk/shares/ftp-tmp will need uploaded manually via WINScp on PGP10 using akronmillsftp account"
echo "Forward email to: CrimsonCPRMDataAnalysts@advisory.com"
echo "Then remove files in /usr/lnk/shares/ftp-tmp"

#echo 
#echo "--> Transferring file to ${TR_ID}..."
#echo
#${TRANSFER_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE} ${TMP_LOC}/${CTRL_FILE}

#echo
#echo "--> Cleaning up..."
#echo

#clean_up

echo "-=> Finished."

exit 0
