#!/bin/ksh
#
# Program Name	: clms_medhealth.sh
# Description	: Procedure to setup claims file for MedHealth (153)
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 01/08/2013
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
REMOTE_DIR="/usr/lnk/wt/abc-94"
TAPE_FILE="???CL111D0-W-MHRX"
LOG_FILE="???CL111D0-W-MHRXTEXT"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="500"
MAIL_PROG="/bin/mail"
MAIL_TO="clayton@medhealthrx.com"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_medhealth.sh -p <p/e date>
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

# Set File names
set_filenames()
{
	CLM_FILE="medhealth_claims_${PE_DATE}.txt"
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
	   mv ${TMP_LOC}/${CLM_FILE} ${REMOTE_DIR}
	   if test $? -ne 0
	     then
		echo "*-> Transfer of file failed"
		rm ${TMP_LOC}/${CLM_FILE}
		exit 1
	   fi
	   cat ${FILE_LOC}/${LOG_FILE} | ${MAIL_PROG} -s "MEDHEALTH WEEKLY CLAIMS FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
	else
	   echo "--*> File not copied..."
	fi
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

echo "-=> Finished."

exit 0
