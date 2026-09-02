#!/bin/ksh
#
# Program Name	: clms_cmc.sh
# Description	: Procedure to setup claims file for CMC(sys69/spo0347)
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 
# Modifications : 03/15/2004 - Changes for new TEXT info. file  (LSJ)
#		: 09/24/2004 - Changed name of tape file from KIN to CMC  (LSJ)
#		: 10/20/2005 - Changes for linux  (LSJ)
#		: 11/27/2005 - Changed system name  (LSJ)
#               : 02/14/2006 - Change /usr/bin/logname to computers@pdmi.com
#		: 06/24/2008 - Removed logic for DES_FILE  (LSJ)
#		: 02/24/2009 - Changed email procedure  (LSJ)
#		: 09/06/2011 - Changed email address
#		: 01/10/2012 - Change for D.0 file name
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL109D0-P-CMC"
LOG_FILE="???CL109D0-P-CMCTEXT"
NEW_LOG="totals.txt"
ZIP_FILE="cmcclms.zip"
CLM_FILE="cmcclms.txt"
ZIP_PROG="/usr/bin/zip"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="300"
MAIL_PROG="/bin/mail"
MAIL_TO="Jim.Frazier@MutualHealthServices.com"
MAIL_CC="operations@pdmi.com"
WT_DIR="/usr/lnk/wt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_cmc.sh -p <p/e date>
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
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  ${CONV_PROG} ${REC_LEN} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	  cp ${FILE_LOC}/${LOG_FILE} ${TMP_LOC}/${NEW_LOG}
	else
	  echo "-*> Claims file does not exist..."
	  exit 1
	fi
}

#
# Zip files
zip_files()
{
	${ZIP_PROG} -mj ${TMP_LOC}/${ZIP_FILE} ${TMP_LOC}/${CLM_FILE} ${TMP_LOC}/${NEW_LOG}
}

#
# Copy files
copy_files()
{
	if test -f ${TMP_LOC}/${ZIP_FILE}
	then
	   cp ${TMP_LOC}/${ZIP_FILE} ${DEST_LOC}
	   echo "The file, ${ZIP_FILE} for P/E ${PE_DATE}, is now available." | ${MAIL_PROG} -s "CMC BI_WEEKLY CLAIMS FILE NOTIFICATION" -c ${MAIL_CC} ${MAIL_TO}
	else
	   echo "--*> File not copied..."
	fi
}

#
# Cleanup
clean_up()
{
	rm ${TMP_LOC}/${ZIP_FILE}
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

DEST_LOC="${WT_DIR}/cmc-wt"

echo
echo "--> Renaming files for archival..."
echo

rename_files

echo
echo "--> Zipping current files..."
echo

zip_files

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
