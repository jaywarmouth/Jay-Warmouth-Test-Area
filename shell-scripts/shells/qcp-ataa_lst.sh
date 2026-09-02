#!/bin/ksh
#
# Program Name	: qcp-ataa_lst.sh
#		  Command Line Arguments:
#		  -d <ccyymmdd> - date on elig. file sent
# Description	: Moves and creates listing of the QCP-ATA(sys71/spo0603) eligibility file
# Author	: Linda S. Jefferis
# Date		: 04/02/2010
# Modifications : 09/08/2010 - Added logic for accumulator file
#		: 11/9/2012 - Changes for new transfer method and X12 file format for eligibility.
#		: 06/30/2014 - Added changes and variables to be able to run decrypt_file.sh
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
ELIG_DIR="/usr/lnk/elig_in"
ELIG_ARCH="/usr/lnk/elig_in_1"
ELIG_LOG="/usr/lnk/elig_in/logs"
SYS_DIR="sys0071"
CLIENT="at"
INPUT_DATE="null"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
REMOTE_SYS="husk"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"
FTP_DIR="/usr/lnk/wt/ataa-ftps/ToPDMI"
PGP_SCRPT="/usr/lnk/shell/decrypt_file.sh"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: qcp-ataa_lst.sh -d <ccyymmdd>

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
	ELIG_FILE="ATAElig_${INPUT_DATE}"
	PGP_FILE="ATAElig_${INPUT_DATE}.pgp"
	#ACCUM_FILE="ATAAccumulator${INPUT_DATE}.txt"
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
        scp ${REMOTE_SYS}:${REMOTE_DIR}/${ELIG_FILE} ${ELIG_DIR}
        if test $? -ne 0
        then
          echo "--*> SCP of file from ${REMOTE_SYS} failed"
          exit 1
        fi
        rm -f ${FTP_DIR}/${PGP_FILE}
}

#
# Move files appropriately
move_files()
{
   if test -a ${ELIG_DIR}/${ELIG_FILE}
   then
        mv ${ELIG_DIR}/${ELIG_FILE} ${ELIG_DIR}/${CLIENT}e${DATE}-X12
        cp ${ELIG_DIR}/${CLIENT}e${DATE}-X12 ${ELIG_ARCH}
   else
	echo "-*> The file, ${ELIG_FILE}, does not exist."
   fi
}

#
# Create listing
create_listing()
{
        LOG_NAME=${CLIENT}-${DATE}.log
        cd ${ELIG_DIR}
        echo "QCP-ATA(sys71/spo0603) Eligibility File" > ${ELIG_LOG}/${LOG_NAME}
        echo "------------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}e${DATE}-X12 >> ${ELIG_LOG}/${LOG_NAME}
        #ls -l ${CLIENT}l${DATE} >> ${ELIG_LOG}/${LOG_NAME}
        cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}

#
# Cleanup
cleanup()
{
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

echo "--> SCP file from ${REMOTE_SYS}"
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
