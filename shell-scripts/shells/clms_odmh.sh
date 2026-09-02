#!/bin/ksh
#
# Program Name	: clms_odmh.sh
# Description	: Procedure to setup claims file for ODMH (sys85)
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 03/10/2006
# Modifications : 12/03/2007 - Removed DES file logic  (LSJ)
#               : 02/17/2009 - Changed MAIL_TO and added MAIL_CC  (LSJ)
#		: 01/05/2012 - Changed name for D.0 and made requested email address changes
#		: 07/10/2012 - Changed email contacts
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL109D0-T-ODMH"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="300"
MAIL_PROG="/bin/mail"
MAIL_TO="donald.chance@mh.ohio.gov Michael.Cannon@mh.ohio.gov ProdControl@mh.ohio.gov James.Dickson@mh.ohio.gov maria.foster@mh.ohio.gov"
MAIL_CC="operations@pdmi.com"
WT_DIR="/usr/lnk/wt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_odmh.sh -p <p/e date>
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
	YEAR=`echo ${PE_DATE} | cut -c7-8`
}

#
# Set Filenames
set_filenames()
{
	CLM_FILE="pdmi${YEAR}${MON}${DAY}.txt"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_LEN} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	  REC_CNT=`wc -l ${TMP_LOC}/${CLM_FILE} | awk '{print $1}'`
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
	   cp ${TMP_LOC}/${CLM_FILE} ${DEST_LOC}
	   echo "The file, ${CLM_FILE}, is now available to download. Record Count = ${REC_CNT}." | ${MAIL_PROG} -s "ODMH BI_MONTHLY CLAIMS FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
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
	conv_date
	;;
  esac
  shift
done

# Parse environment variables
parse_env

DEST_LOC="${WT_DIR}/odmh-wt"

set_filenames

echo
echo "--> Renaming files for archival..."
echo

rename_files

echo 
echo "--> Copying file to ${DEST_LOC}..."
echo

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
