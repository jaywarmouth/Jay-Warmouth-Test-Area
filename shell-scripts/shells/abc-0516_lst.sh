#!/bin/ksh
#
# Program Name	: abc-0516_lst.sh
# Description	: Creates log listing of ABC/Ancillary Medical eligibility file.
#                 Command Line Arguments:
#                 -d <mmdd> - current date.
#                 -f <elig. filename sent>
# Author	: Linda S. Jefferis
# Date		: 04/24/2008 
# Modifications : 04/29/2008 - Added "-f" logic
#		: 05/07/2008 - Added logic for file existence checking
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
REMOTE_DIR="/usr/lnk/wt/anms-wt/ToPDMI"
REMOTE_SYS="husk"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
SYS="sys0075"
DATE="null"
CLIENT="an"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: abc-0516_lst.sh [-d <mmdd>]

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
# Move Files
move_files()
{
	if ! test -a ${REMOTE_DIR}/${ELIG_FILE}
	then
	  echo "-*> Incorrect elig. filename...exiting process"
	  exit 1
	fi
	cp ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_ARCH}/${SYS}
	if test -a ${ELIG_DIR}/${CLIENT}e${DATE}-XLS
	then
		echo "-*> ${ELIG_DIR}/${CLIENT}e${DATE}-XLS already exists."
		echo "-*> Check command line entered..."
		exit 1
	fi
	mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}-XLS
	cp ${ELIG_DIR}/${CLIENT}e${DATE}-XLS ${ELIG_ARCH}
}

#
# Create Listing
create_listing()
{
	LOG_NAME=abc-0516-${DATE}.log
        cd ${ELIG_DIR}
        echo "ABC/Ancillary Medical (spo0516) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "---------------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${DATE}-XLS >> ${ELIG_LOG}/${LOG_NAME}
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
        DATE=$1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        ELIG_FILE=$1
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
