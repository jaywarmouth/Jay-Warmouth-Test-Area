#!/bin/sh
#
# Program Name	: myo-elig_lst.sh
#		  Command Line Arguments:
#		  -d <yyyymmdd> - date on elig. file sent
# Description	: Moves and creates listing of the MyoDerm (sys0196) eligibility file
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_DIR="/usr/lnk/elig_in"
ELIG_ARCH="/usr/lnk/elig_in_1"
ELIG_LOG="/usr/lnk/elig_in/logs"
CLIENT="my"
INPUT_DATE="null"
REMOTE_DIR="/usr/lnk/wt/benefit-wt/Myoderm/EligFiles"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
SHELL_DIR="/usr/lnk/shell"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: myo-elig_lst.sh -d <yyyymmdd>

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
	ELIG_FILE="MYOelig-${INPUT_DATE}.csv"
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
	   perl -i.bak -pe 's/[^[:ascii:]]//g' ${ELIG_DIR}/${CLIENT}e${DATE}-XLS
	   rm -f ${ELIG_DIR}/${CLIENT}e${DATE}-XLS.bak
	   cp ${ELIG_DIR}/${CLIENT}e${DATE}-XLS ${ELIG_ARCH}
	fi
}

conv_file()
{
	${SHELL_DIR}/crdxls01.sh -f ${CLIENT}e${DATE}
}

#
# Create listing
create_listing()
{
        LOG_NAME=i${CLIENT}-${DATE}.log
        cd ${ELIG_DIR}
        echo "Myoderm (196) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "NOTE: The crdxls01 conversion is already run on file" >> ${ELIG_LOG}/${LOG_NAME}
        echo "-------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${DATE}* >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}


# Parse environment variables
#parse_env

echo
echo "--> Moving files"
move_files

conv_file

echo
echo "--> Creating and printing listing"
create_listing

exit 0
