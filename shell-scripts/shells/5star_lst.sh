#!/bin/ksh
#
# Program Name	: 5star_lst.sh
#		  Command Line Arguments:
#		  -d <ccyymmdd> - date on elig. file sent
#		  -f <elig. filename sent>
# Description	: Moves and creates listing of the 5 Star (sys0111) eligibility file
# Author	: Linda S. Jefferis
# Date		: 10/27/2008
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_DIR="/usr/lnk/elig_in"
ELIG_ARCH="/usr/lnk/elig_in_1"
ELIG_LOG="/usr/lnk/elig_in/logs"
SYS_DIR="sys0111"
CLIENT="fs"
DATE="null"
REMOTE_DIR="/usr/lnk/wt/five-wt"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: 5star_lst.sh -d <ccyymmdd>

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
# Convert the date
convert_date()
{
        DATE=`echo ${INPUT_DATE} | cut -c5-8`
}

#
# Set Filenames
set_filename()
{
        ELIG_FILE="MORx_${INPUT_DATE}.txt"
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


#
# Move files appropriately
move_files()
{
	if test -a ${REMOTE_DIR}/${ELIG_FILE}
	then
	   mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}
	   cp ${ELIG_DIR}/${CLIENT}e${DATE} ${ELIG_ARCH}
	fi
}

#
# Create listing
create_listing()
{
        LOG_NAME=5star-${DATE}.log
        cd ${ELIG_DIR}
        echo "5Star (sys0111) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "-------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}


# Parse environment variables
#parse_env

echo
echo "--> Moving files"
move_files

echo
echo "--> Creating and printing listing"
create_listing

exit 0
