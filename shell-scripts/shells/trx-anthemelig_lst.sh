#!/bin/ksh
#
# Program Name	: trx-anthemelig_lst.sh
# Description	: Moves files and creates log listing of TRX-Anthem eligibility file.
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on file sent.
# Author	: Linda S. Jefferis
# Date		: 10/15/2015
# Modifications : 12/03/2015 - replace benefits@pdmi.com with elig_accum@pdmi.com (DME,TT13915-17)
#
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
INPUT_DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_LOG=/usr/lnk/elig_in/logs
ELIG_ARCH="/usr/lnk/elig_in_1"
REMOTE_DIR="/usr/lnk/wt/oper-wt/elig/TRXAnthem/ToPDMI"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
MAIL_PROG="/bin/mail"
MAIL_TO="elig_accum@pdmi.com operations@pdmi.com"
CLIENT="lb"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: trx-anthemelig_lst.sh [-d <ccyymmdd>]

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
        DATE=`echo ${INPUT_DATE} | cut -c5-8`
}

#
# Set Filenames
set_filename()
{
	ELIG_FILE="TRXAnthem_elig_${INPUT_DATE}.txt"
}

#
# Move Files
move_files()
{
        if ! test -a ${REMOTE_DIR}/${ELIG_FILE}
        then
          echo "-*> Incorrect elig. filename...exiting process"
          exit 1
	else
          mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}
          cp ${ELIG_DIR}/${CLIENT}e${DATE} ${ELIG_ARCH}
        fi
}

#
# Create Listing
create_listing()
{
        LOG_NAME=${CLIENT}e-${DATE}.log
        cd ${ELIG_DIR}
        echo "TrueRx-Anthem Eligibility Files" > ${ELIG_LOG}/${LOG_NAME}
        echo "---------------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
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

if [ ${INPUT_DATE} = "null" ]
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
