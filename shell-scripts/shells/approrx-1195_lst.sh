#!/bin/ksh
#
# Program Name	: approrx-1195_lst.sh
# Description	: Moves files and creates log listing of ApproRx-1195 eligibility file.
#                 Command Line Arguments:
#                 -d <mmddccyy> - date on file sent.
# Author	: Linda S. Jefferis
# Date		: 12/14/2012


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
REMOTE_DIR="/usr/lnk/wt/oba-ftps/ToPDMI"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
CLIENT="ob"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: approrx-1195_lst.sh [-d <mmddccyy>]

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
	ELIG_FILE="EBC_${INPUT_DATE}_834.DAT"
}

#
# Move Files
move_files()
{
        if ! test -e ${REMOTE_DIR}/${ELIG_FILE}
        then
          echo "-*> Incorrect elig. filename...exiting process"
          exit 1
        fi
        mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}-X12
        cp ${ELIG_DIR}/${CLIENT}e${DATE}-X12 ${ELIG_ARCH}
}

#
# Create Listing
create_listing()
{
        LOG_NAME=${CLIENT}e-${DATE}.log
        cd ${ELIG_DIR}
        echo "ApproRx-1195 Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "---------------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${DATE}-X12 >> ${ELIG_LOG}/${LOG_NAME}
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
