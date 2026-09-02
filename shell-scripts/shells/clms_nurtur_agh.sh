#!/bin/sh
#
# Program Name	: clms_nurtur_agh.sh
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
TMP_LOC="/usr/lnk/shares/ftp-tmp"
TAPE_FILE="???CL109D0-M-AGH"
TEXT_FILE="???CL109D0-M-AGHTEXT"
PE_DATE="null"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="300"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_nurtur_agh.sh -p <p/e date>
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


#
# Set filenames
set_filenames()
{
	CLM_FILE="Nurtur_agh_claims_${PE_DATE}.txt"
	CTRL_FILE="Nurtur_agh_control_${PE_DATE}.txt"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	  cp ${FILE_LOC}/${TEXT_FILE} ${TMP_LOC}/${CTRL_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
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

echo "The 2 Nurtur files in /usr/lnk/shares/ftp-tmp will need uploaded manually via WINScp on PGP10 to Inbound folder of pharm_data@sftp.nurturhealth.com account"
echo "Then remove files in /usr/lnk/shares/ftp-tmp"


echo "-=> Finished."

exit 0
