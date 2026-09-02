#!/bin/ksh
#
# Program Name	: clms_lockton_ncmc.sh
# Description	: Procedure to setup claims files for Lockton (spo0602). 
#		  Command Line Arguments:
#		  -p <mmccyy>  M/E date
# Author	: Linda S. Jefferis
# Date		: 11/05/2013
# Modification	: 02/17/2014 - Fixed issue with CLM_FILE9 being used instead of CLM_FILE in conv command. Data files were not being included.
#		: 11/04/2014 - Update email contact
#		: 10/27/2016 - Remove invalid rdorsel@lockton.com address
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL109D0-M-NCMC"
LOG_FILE="???CL109D0-M-NCMCTEXT"
ZIP_PROG="/usr/bin/zip"
MAIL_PROG="/bin/mail"
MAIL_TO="infolock@lockton.com"
MAIL_CC="operations@pdmi.com"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="300"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="LOCKTON"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_lockton_ncmc.sh -p <m/e date>
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
	CLM_FILE="ncmc${PE_DATE}.txt"
	ZIP_FILE="ncmc${PE_DATE}.zip"
	NEW_LOG="ncmc_totals.txt"
}

#
rename_files()
{
	${CONV_PROG} ${REC_SIZE} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${CLM_FILE}
	cp ${FILE_LOC}/${LOG_FILE} ${TMP_LOC}/${NEW_LOG}
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
	${TR_PROG} ${TR_ID} ${TMP_LOC}/${ZIP_FILE}
	if test $? -ne 0
	then
		echo "*-> Transfer of file failed"
                clean_up
                exit 1
        fi
	echo "The monthly NCMC file for ${MON}/${YEAR} is now available." | ${MAIL_PROG} -s "Lockton - NCMC Monthly Claims File Notification" -c ${MAIL_CC} ${MAIL_TO}
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
#parse_env

set_filenames

echo
echo "--> Renaming files for archival..."
echo

rename_files

echo
echo "--> Zipping current files..."
echo

zip_files

echo 
echo "--> Transferring files..."
echo

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
