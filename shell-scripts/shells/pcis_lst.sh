#!/bin/ksh
#
# Program Name	: pcis_lst.sh
#		  Command Line Arguments:
#		  -d <ccyymmdd> - date included in file name sent
# Description	: Moves and creates listing of the PCIS (sys155) eligibility file
# Author	: Linda S. Jefferis
# Date		: 09/27/2012
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_DIR="/usr/lnk/elig_in"
ELIG_ARCH="/usr/lnk/elig_in_1"
ELIG_LOG="/usr/lnk/elig_in/logs"
SYS_DIR="sys0155"
INPUT_DATE="null"
REMOTE_DIR="/usr/lnk/wt/pcis-wt/ToPDMI"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
INPUT_DATE="null"
CLIENT="pp"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pcis_lst.sh -d <ccyymmdd>

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
        ELIG_FILE="pcis_elig_${INPUT_DATE}.csv"
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


#
# Move files appropriately
move_files()
{
	if test -a ${REMOTE_DIR}/${ELIG_FILE}
	then
	   mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}-XLS
	   cp ${ELIG_DIR}/${CLIENT}e${DATE}-XLS ${ELIG_ARCH}
	fi
}

#
# Create listing
create_listing()
{
        LOG_NAME=${CLIENT}-${DATE}.log
        cd ${ELIG_DIR}
        echo "PCIS (sys0155) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "-------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${DATE}-XLS >> ${ELIG_LOG}/${LOG_NAME}
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
