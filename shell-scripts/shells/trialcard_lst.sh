#!/bin/sh
#
# Program Name	: trialcard_lst.sh
#		  Command Line Arguments:
#		  -f <input filename> - no directory name included
#		  -d <mmdd> - date on elig. file sent
# Description	: Moves and creates listing of the special "Add Member Range" requests.
# Author	: Linda S. Jefferis
# Date		: 02/03/2012
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
SYS_DIR="sys0078"
DATE="null"
REMOTE_DIR="/usr/lnk/wt/benefit-wt/ToPDMI"
CLIENT="tc"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="ljefferis@pdmi.com"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: trialcard_lst.sh -f <filename> -d <mmdd-reference#>
	where <filename> is name of file in $REMOTE_DIR


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
# Get file from remote system
get_file()
{
        cp ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}
        if test $? -ne 0
        then
          echo "--*> SCP of ${ELIG_FILE} from ${REMOTE_SYS} failed"
          exit 1
        fi
}


#
# Move files appropriately
move_files()
{
	if ! test -a ${ELIG_DIR}/${ELIG_FILE}
        then
          echo "-*> Incorrect elig. filename...exiting process"
          exit 1
        fi
	cp ${ELIG_DIR}/${ELIG_FILE} ${ELIG_ARCH}/${SYS_DIR}
        mv ${ELIG_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}
        cp ${ELIG_DIR}/${CLIENT}e${DATE} ${ELIG_ARCH}
}

#
# Create listing
create_listing()
{
        LOG_NAME=${CLIENT}-${DATE}.log
        cd ${ELIG_DIR}
        echo "Mercalis Add Members File" > ${ELIG_LOG}/${LOG_NAME}
	echo "Batch File Name: ${ELIG_FILE}"
        echo "-------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${DATE} >> ${ELIG_LOG}/${LOG_NAME}
        cat ${ELIG_LOG}/${LOG_NAME} 
}

#
# Cleanup
cleanup()
{
	rm -f ${REMOTE_DIR}/${ELIG_FILE}
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
	ELIG_FILE="tce${DATE}.txt"
        ;;
  esac
  shift
done

if [ ${DATE} = "null" ]
then
   usage
fi

# Parse environment variables
#parse_env

echo "--> CP file from ${REMOTE_DIR}"
get_file

echo
echo "--> Moving files"
move_files

echo
echo "--> Creating and displaying listing"
create_listing

echo
echo "--> Doing cleanup"
cleanup

exit 0
