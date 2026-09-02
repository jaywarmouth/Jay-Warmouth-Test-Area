#!/bin/ksh
#
# Program Name	: ssc_lst.sh
# Description	: Moves and lists the SSC eligibility file
#		  Command Line Arguments:
# Author	: Linda S. Jefferis
# Date		: 07/08/2003
# Modifications : 10/26/2005 - Changes for Linux  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
LPDEST=HP5Si_1
SHELL_DIR="/usr/lnk/shell"
ELIG_DIR=/usr/lnk/elig_in
ELIG_ARCH=/usr/lnk/elig_in_1
ELIG_LOG=/usr/lnk/elig_in/logs
SYS="063"
REMOTE_DIR="/usr/lnk/wt/sscdata"
FNAME="MC??????????????.DAT"
CURR_DAY=`date +%w`
MAIL_ERROR="ljefferis@pdmi.com"
MAIL_LIST="benefits@pdmi.com"
MAIL_PROG="/bin/mail"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ssc_lst.sh 

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
        cd ${REMOTE_DIR}
	echo "FNAME=${FNAME}"
        DAY=`echo ${FNAME} | cut -c3-4`
	MON=`echo ${FNAME} | cut -c5-6`
	TIME=`echo ${FNAME} | cut -c11-16`
	DATE=${MON}${DAY}
        INPUT_DATE=`echo ${FNAME} | cut -c3-16`
	echo "INPUT_DATE=${INPUT_DATE}"
}

#
# Set Filenames
set_filename()
{
	convert_date
	ELIG_FILE="MC${INPUT_DATE}.DAT"
	echo "ELIG_FILE=${ELIG_FILE}"
}

#
# Move files appropriately
move_files()
{
	set_filename
	if test -f ${REMOTE_DIR}/${ELIG_FILE}
	then
	   if [ ${CURR_DAY} = "0" -o ${CURR_DAY} = "6" ]
	   then
		mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_ARCH}/sys${SYS}
		${SHELL_DIR}/zip_arch_elig.sh -t elig -e 0 -c ss -d ${DATE} -s ${SYS}
	   else
		mv ${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/sse${DATE}
		cp ${ELIG_DIR}/sse${DATE} ${ELIG_ARCH}
		create_listing
	   fi
	else
	   echo "Error occurred with the ssc_lst.sh procedure" | ${MAIL_PROG} -s "ssc_lst.sh Procedure" ${MAIL_ERROR}
	fi
}
	   
#
# Create listing
create_listing()
{
        LOG_NAME=ssc${DATE}.log
        cd ${ELIG_DIR}
        echo "Script Sense Canada Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l sse${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	#lp -d ${LPDEST} ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "SSC Eligibility" ${MAIL_LIST}
}

#
# Main routine
#

# Check command line validity, call usage if incorrect

move_files

# Parse environment variables
parse_env

exit 0
