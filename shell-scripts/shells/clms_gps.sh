#!/bin/sh
#
# Program Name	: clms_gps.sh
# Description	: Procedure to transfer claims data files to GPS
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 05/08/2008
# Modifications : 08/21/2008 - Addition of email notification logic  (LSJ)
#		: 01/05/2012 - Changed name for D.0
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
DEST_LOC="/usr/lnk/shares/ftp-tmp"
TMP_LOC="/tmp"
TAPE_FILE="???CL111D0-T-JHS"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com john@globalpharmaceuticalsolutions.com"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="500"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="GPS"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_gps.sh -p <p/e date>
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


#
# Set Filenames
set_filenames()
{
	CLM_FILE="gps-clms${PE_DATE}.txt"
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
	   echo "The file, ${CLM_FILE}.pgp, from PDMI has been uploaded." | ${MAIL_PROG} -s "GPS CLAIMS FILE NOTIFICATION" ${MAIL_TO}
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
