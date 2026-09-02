#!/bin/ksh
#
# Program Name	: ebi-medben_lst.sh
# Description	: Creates log listing of EBI-MedBen Eligibility file.
#                 Command Line Arguments:
#                 -d <mmdd> - current date.
# Author	: Linda S. Jefferis
# Date		: 10/19/2007
# Modifications : 06/03/2013 - Removed zip_arch_elig.sh procedure (DME)
#		: 07/01/2014 - add logic and variables to run decrypt_file.sh (TT:10901-1)(DME)
#		: 07/09/2014 - change logic to be able to run with multiple files in the ftp directory. (DME)
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_ARCH=/usr/lnk/elig_in_1
ELIG_LOG=/usr/lnk/elig_in/logs
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
REMOTE_SYS="husk"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
SHELL="/usr/lnk/shell"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com computers@pdmi.com"
CLIENT="eb"
SYS="0049"
FTP_DIR="/usr/lnk/wt/evb-ftp/topdm"
PGP_SCRPT="/usr/lnk/shell/decrypt_file.sh"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ebi-medben_lst.sh [-d <ccyy-mm-dd>]

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
#Convert the date
convert_date()
{
        ELIG_DATE=`echo ${DATE} | cut -c6,7,9,10`
}

#
#Set file names
set_file()
{
PGP_FILE="PDMI_eligibility_${DATE}T??????.txt.asc"
ELIG_FILE="tmp${ELIG_DATE}.tmp"
}


#
# Get file from remote system
get_file()
{
         scp ${FTP_DIR}/${PGP_FILE} ${REMOTE_SYS}:${REMOTE_DIR}
        if test $? -ne 0
        then
             echo "--*> SCP of ${PGP_FILE} failed"
             exit 1
        fi
        ${PGP_SCRPT} ${PGP_FILE}  ${ELIG_FILE}
       scp ${REMOTE_SYS}:${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${ELIG_DATE}
        if test $? -ne 0
        then
          echo "--*> SCP of file from ${REMOTE_SYS} failed"
          exit 1
        fi
	chmod 770 ${ELIG_DIR}/${CLIENT}e${ELIG_DATE}
        chgrp pdm ${ELIG_DIR}/${CLIENT}e${ELIG_DATE}
	
	rm -f ${FTP_DIR}/${PGP_FILE}
}


#
# Create Listing
create_listing()
{
	LOG_NAME=ebi-medben${ELIG_DATE}.log
        cd ${ELIG_DIR}
        echo "EBI-MedBen Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${ELIG_DATE} >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}

#
# Cleanup
cleanup()
{
	cp ${ELIG_DIR}/${CLIENT}e${ELIG_DATE} ${ELIG_ARCH}/sys${SYS}
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${ELIG_FILE}"
        ssh ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${PGP_FILE}"
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
	convert_date
	set_file
	;;
  esac
  shift
done

if [ ${DATE} = "null" ]
then
   usage
fi


echo "--> SCP file from ${REMOTE_SYS}"
get_file

echo
echo "--> Creating and printing listing"
create_listing

echo
echo "--> Doing cleanup"
cleanup

exit 0
