#!/bin/ksh
#
# Program Name	: clms_abc_0553.sh
# Description	: Procedure to provide data files for sponsor 553 to QISS 
#		  Command Line Arguments:
#		  -p <mmddccyy>  P/E date
# Author	: Linda S. Jefferis
# Date		: 10/09/2008
# Modifications : 10/30/2008 - Removed CONV_PROG logic. Development adding CR/LF characters through program.
#		: 08/24/2009 - Changed "O" to "P" in file names  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/tapes"
TMP_LOC="/tmp"
TAPE_FILE="???CL132HDR-P-QISS"
TAPE_FILE_2="???CL132ITEM-P-QISS"
TEXT_FILE="???QISSTEXT"
ZIP_PROG="/usr/bin/zip"
CONV_PROG="/usr/local/bin/addlf"
REC_LEN="1290"
REC_LEN_2="212"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
MAIL_TEXT="laura@ancillarymedicalserv.com"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="QISS"
PE_DATE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clms_abc_0553.sh -p <p/e date>
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
	HDR_FILE="BillHeader${YEAR}${MON}${DAY}_PDM_TIS.TXT"
	ITEM_FILE="BillItem${YEAR}${MON}${DAY}_PDM_TIS.TXT"
	ZIP_FILE="QISS${YEAR}${MON}${DAY}_PDM_TIS.zip"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${TAPE_FILE}
	then
	  #${CONV_PROG} ${REC_LEN} ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${HDR_FILE}
	  cp ${FILE_LOC}/${TAPE_FILE} ${TMP_LOC}/${HDR_FILE}
	else
	  echo "-*> HDR file does not exist..."
	  exit 1
	fi
	if test -s ${FILE_LOC}/${TAPE_FILE_2}
	then
	  #${CONV_PROG} ${REC_LEN_2} ${FILE_LOC}/${TAPE_FILE_2} ${TMP_LOC}/${ITEM_FILE}
	  cp ${FILE_LOC}/${TAPE_FILE_2} ${TMP_LOC}/${ITEM_FILE}
	else
	  echo "-*> ITEM file does not exist..."
	  exit 1
	fi
}

#
# Zip files
zip_files()
{
	${ZIP_PROG} -mj ${TMP_LOC}/${ZIP_FILE} ${TMP_LOC}/${HDR_FILE} ${TMP_LOC}/${ITEM_FILE}
}

#
# Copy files
copy_files()
{
	if test -f ${TMP_LOC}/${ZIP_FILE}
	then
	   ${TR_PROG} ${TR_ID} ${TMP_LOC}/${ZIP_FILE}
	   if test $? -ne 0
	   then
		echo "*-> Transfer of file failed"
		clean_up
		exit 1
	   fi
	  #echo "The file, ${ZIP_FILE}.pgp for P/E ${PE_DATE}, is now available." | ${MAIL_PROG} -s "QISS-TRINITY DATA FILE NOTIFICATION" ${MAIL_TO}
	   cat ${FILE_LOC}/${TEXT_FILE} | ${MAIL_PROG} -s "QISS-TRINITY DATA FILE INFORMATION" ${MAIL_TO} ${MAIL_TEXT}
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
#parse_env

if [ ${PE_DATE} = "null" ]
then
	usage
fi

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
echo "--> Copying file..."
echo

copy_files

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
