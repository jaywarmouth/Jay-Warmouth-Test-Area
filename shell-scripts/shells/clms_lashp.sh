#!/bin/ksh
#
# Program Name	: clms_lashp.sh
# Description	: Procedure to setup claims file for LASH/PAN
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 07/22/2005
# Modifications : 10/26/2005 - Changes for Linux  (LSJ) 
#               : 02/14/2006 - Change /usr/bin/logname to computers@pdmi.com
#		: 06/12/2007 - Changed logic to use secure_transfer.sh
#               : 02/17/2009 - Changed MAIL_TO and added MAIL_CC  (LSJ)
#		: 12/28/2011 - Changed file names for D.0 format
#		: 08/28/2014 - TT #11688-1 - Change to "X" cycle
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL111D0-X-LASH"
LOG_FILE="???CL111D0-X-LASHTEXT"
ZIP_PROG="/usr/bin/zip"
MAIL_PROG="/bin/mail"
MAIL_TO="biztalkadmins@lashgroup.com PANFTechCLT@lashgroup.com"
MAIL_CC="operations@pdmi.com"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="LASHP-BIMONTHLY"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_lashp.sh -p <p/e date>
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
# Split out p/e date
conv_date()
{
	MON=`echo ${PE_DATE} | cut -c1-2`
	DAY=`echo ${PE_DATE} | cut -c3-4`
	YEAR=`echo ${PE_DATE} | cut -c5-8`
}

#
# Set Filenames
set_filenames()
{
	CLM_FILE="lashp-bimon${MON}${DAY}.txt"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  cp ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	  ${TR_PROG} ${TR_ID} ${TMP_LOC}/${CLM_FILE}
          if test $? -ne 0
            then
                echo "*-> Transfer of file failed"
                clean_up
                exit 1
            fi
	  cat ${FILE_LOC}/${LOG_FILE} | ${MAIL_PROG} -s "LASH-PAN CLAIMS FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
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

clean_up

echo "-=> Finished."

exit 0
