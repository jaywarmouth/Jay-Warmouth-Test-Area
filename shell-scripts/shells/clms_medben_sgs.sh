#!/bin/sh
#
# Program Name	: clms_medben_sgs.sh
# Description	: Procedure to transfer a claims data file for SGS Tool to HCRM
#		  Command Line Arguments:
#		  -p <mmccyy>  M/E date
# Author	: Linda S. Jefferis
# Date		: 01/31/2007
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
DEST_LOC="/usr/lnk/shares/ftp-tmp"
TMP_LOC="/tmp"
TAPE_FILE="???CL109-M-SGS"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="300"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="HCRM"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_medben_sgs.sh -p <m/e date>
	<m/e date> is month ending date in mmccyy format  (required)

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
# Split out m/e date
conv_date()
{
        MON=`echo ${PE_DATE} | cut -c1-2`
        YEAR=`echo ${PE_DATE} | cut -c3-6`
}



#
# Set Filenames
set_filenames()
{
	CLM_FILE="sgs${PE_DATE}.txt"
}


#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
          ${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE} ${DEST_LOC}/${CLM_FILE}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}

#
# Transfer files
transfer_file()
{
	if test -f ${DEST_LOC}/${CLM_FILE}
	then
	   ${TR_PROG} ${TR_ID} ${DEST_LOC}/${CLM_FILE}
	   if test $? -ne 0
	   then
		echo "*-> Transfer of file failed"
	   fi
	else
	   echo "--*> File not copied..."
	fi
}

#
# Cleanup
clean_up()
{
	rm ${DEST_LOC}/${CLM_FILE}
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
	;;
  esac
  shift
done

# Parse environment variables
#parse_env

set_filenames

echo
echo "--> Renaming files for archival..."
echo

rename_files

echo 
echo "--> Transferring file..."
echo

transfer_file

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
