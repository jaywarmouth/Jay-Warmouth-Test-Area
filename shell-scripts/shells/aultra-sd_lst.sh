#!/bin/ksh
#
# Program Name	: aultra-sd_lst.sh
#		  Command Line Arguments:
#		  -d <ccyymmdd> - date on elig. file sent
# Description	: Moves and creates listing of the Aultra (sys53/spo0479) eligibility file
# Author	: Linda S. Jefferis
# Date		: 07/19/2006
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
SYS_DIR="sys053"
DATE="null"
REMOTE_DIR="/usr/lnk/wt/atra-01"
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: aultra-sd_lst.sh -d <ccyymmdd>

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
# Set Filenames
set_filename()
{
	ELIG_FILE="${INPUT_DATE}.TXT"
	if ! test -a ${REMOTE_DIR}/${INPUT_DATE}.TXT
	then
		echo "${REMOTE_DIR}/${ELIG_FILE} does not exist"
		exit 1
	fi	
}

#
# Convert the date
convert_date()
{
        DATE=`echo ${INPUT_DATE} | cut -c5-8`
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
        mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/sde${DATE}
        cp ${ELIG_DIR}/sde${DATE} ${ELIG_ARCH}
}

#
# Create listing
create_listing()
{
        LOG_NAME=aultra${DATE}.log
        cd ${ELIG_DIR}
        echo "Aultra/Superior Dairy (sys53/spo0479) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "-------------------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l sde${DATE} >> ${ELIG_LOG}/${LOG_NAME}
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
