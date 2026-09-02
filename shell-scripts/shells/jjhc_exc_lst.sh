#!/bin/ksh
#
# Program Name	: jjhc_exc_lst.sh
# Description	: Creates log listing of Assist Rx (123) eligibility, accumulator, and exception files.
#                 Command Line Arguments:
#                 -d <mmddccyy> - date on elig. file sent.
# Author	: Linda S. Jefferis
# Date		: 01/06/2010
# Modifications : 02/19/2010 - Logic changes to handle auto archiving of the zero byte files that are sent and provide special message in listing.
#		: 03/03/2010 - Added REC_CNT logic
#               : 06/03/2013 - Removed zip_arch_elig.sh procedure (DME)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL="/usr/lnk/shell"
DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_ARCH=/usr/lnk/elig_in_1
ELIG_LOG=/usr/lnk/elig_in/logs
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
REMOTE_SYS="husk"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
DATE="null"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
CLIENT="jj"
SYS="0088"
EXC=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: jjhc_exc_lst.sh [-d <ccyymmdd>]

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
        EXC_PGP_FILE="JOM_Eligibility_${INPUT_DATE}.txt.pgp"
	EXC_FILE="JOM_Eligibility_${INPUT_DATE}.txt"
}

#
# Get file from remote system
get_file()
{
        scp ${REMOTE_SYS}:${REMOTE_DIR}/${EXC_FILE} ${ELIG_DIR}
        if test $? -ne 0
        then
          echo "--*> SCP of EXC file from ${REMOTE_SYS} failed"
          exit 1
        fi
}

#
# Move Files
move_files()
{
	### EXC File
	if test -e ${ELIG_DIR}/${EXC_FILE}
	then
		if test -s ${ELIG_DIR}/${EXC_FILE}
		then
			EXC=1
			mv ${ELIG_DIR}/${EXC_FILE} ${ELIG_DIR}/${CLIENT}x${DATE}
			cp ${ELIG_DIR}/${CLIENT}x${DATE} ${ELIG_ARCH}
		else
			mv ${ELIG_DIR}/${EXC_FILE} ${ELIG_ARCH}/sys${SYS}/${CLIENT}x${DATE}
		fi
	else
		echo "-*> Incorrect EXC filename..."
	fi
}

#
# Create Listing
create_listing()
{
	LOG_NAME=${CLIENT}x-${DATE}.log
        cd ${ELIG_DIR}
        echo "JJHC (SYS0088) Special Exception File" > ${ELIG_LOG}/${LOG_NAME}
        echo "--------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
	if [ $EXC = 1 ]
	then
		ls -l ${CLIENT}x${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	else
		echo "${CLIENT}x${DATE} has zero records and no processing is needed" >> ${ELIG_LOG}/${LOG_NAME}
	fi
	echo "" >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}

#
# Cleanup
cleanup()
{
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${EXC_FILE}"
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${EXC_PGP_FILE}"
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

echo "--> SCP files from ${REMOTE_SYS}"
get_file

echo
echo "--> Moving files"
move_files

echo
echo "--> Creating and printing listing"
create_listing

echo
echo "--> Doing cleanup"
cleanup

exit 0
