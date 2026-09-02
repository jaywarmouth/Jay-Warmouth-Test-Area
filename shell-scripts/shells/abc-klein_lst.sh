#!/bin/ksh
#
# Program Name	: abc-klein_lst.sh
# Description	: Creates log listing of ABC/Klein's eligibility file.
#                 Command Line Arguments:
#                 -d <mmddccyy> - date on elig. file sent.
# Author	: Linda S. Jefferis
# Date		: 04/16/2009
# Modifications : 05/07/2009 - Changed input date format and added CLIENT
#		: 05/18/2009 - Changed input file name
#		: 06/03/2009 - Changed input date format
#		: 11/11/2009 - Added ToPDMI sub-directory
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_ARCH=/usr/lnk/elig_in_1
ELIG_LOG=/usr/lnk/elig_in/logs
REMOTE_DIR="/usr/lnk/wt/craw-wt/ToPDMI"
DATE="null"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
CLIENT="kl"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: abc-klein_lst.sh [-d <mmddccyy>]

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    IFS=${OLDIFS}
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
# Convert the date
convert_date()
{
        DATE=`echo ${INPUT_DATE} | cut -c1-4`
}


#
# Set Filenames
set_filename()
{
	ELIG_FILE="Kleins_PDMI_${INPUT_DATE}.txt"
}


#
# Move Files
move_files()
{
	if ! test -a ${REMOTE_DIR}/${ELIG_FILE}
	then
	  echo "-*> Incorrect elig. filename...exiting process"
	  exit 1
	fi
	mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}
	cp ${ELIG_DIR}/${CLIENT}e${DATE} ${ELIG_ARCH}
}

#
# Create Listing
create_listing()
{
	LOG_NAME=abc-klein-${DATE}.log
        cd ${ELIG_DIR}
        echo "ABC Managed Care/Klein's(spo0407) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "------------------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
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
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INPUT_DATE=$1
	convert_date
	set_filename
        ;;
  esac
  shift
done

if [ ${DATE} = "null" ]
then
   usage
fi

echo
echo "--> Moving files"
move_files

echo
echo "--> Creating and printing listing"
create_listing

exit 0
