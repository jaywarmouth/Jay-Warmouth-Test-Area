#!/bin/ksh
#
# Program Name	: clms_phd_naa.sh
# Description	: Procedure to setup claims file for PHD (0169)
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 08/14/2014
# Modifications : 09/15/2014 - updated CLMS_FILE name  (LSJ)
#		: 01/15/2015 - Updated TR_ID from "NAA" to "PHDNAA"
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL111D0-W-PHD"
LOG_FILE="???CL111D0-W-PHDTEXT"
ZIP_PROG="/usr/bin/zip"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="500"
MAIL_PROG="/bin/mail"
MAIL_TO="mis@naa-lp.com"
MAIL_CC="operations@pdmi.com"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="PHDNAA"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_phd_naa.sh -p <p/e date>
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
	MON=`echo ${PE_DATE} | cut -c1-2`
        DAY=`echo ${PE_DATE} | cut -c3-4`
        YR=`echo ${PE_DATE} | cut -c5-8`
        FILE_DATE=${YR}${MON}${DAY}
	CLM_FILE="Refreshclms-PHD-${FILE_DATE}.txt"
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
	   echo "The file for P/E ${PE_DATE}, is now available." | ${MAIL_PROG} -s "PHD-NAA WEEKLY CLAIMS FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
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

clean_up

echo "-=> Finished."

exit 0
