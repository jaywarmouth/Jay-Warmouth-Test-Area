#!/bin/sh
#
# Program Name	: evo-bpacaccum_lst.sh
# Description	: Moves files and creates log listing of EVO-BPAC accum file.
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on file sent.
#
#
#
# Variables Used:
INPUT_DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_LOG=/usr/lnk/elig_in/logs
ELIG_ARCH="/usr/lnk/elig_in_1"
REMOTE_DIR="/usr/lnk/wt/oper-wt/accum/EVOBPAC/ToPDMI"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
CLIENT="eb"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: evo-bpacaccum_lst.sh [-d <ccyymmdd>]

ENDOFUSAGE
  exit 1
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
	ACCUM_FILE="EVOBPAC_accum_${INPUT_DATE}.txt"
}

#
# Move Files
move_files()
{
        if ! test -a ${REMOTE_DIR}/${ACCUM_FILE}
        then
          echo "-*> Incorrect accum. filename...exiting process"
          exit 1
	else
          mv ${REMOTE_DIR}/${ACCUM_FILE} ${ELIG_DIR}/${CLIENT}l${DATE}
          cp ${ELIG_DIR}/${CLIENT}l${DATE} ${ELIG_ARCH}
        fi
}

#
# Create Listing
create_listing()
{
        LOG_NAME=${CLIENT}l-${DATE}.log
        cd ${ELIG_DIR}
        echo "EVO-BPAC (Sys0218) Accumulator File" > ${ELIG_LOG}/${LOG_NAME}
        echo "---------------------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
        echo "" >> ${ELIG_LOG}/${LOG_NAME}
        ls -l ${CLIENT}l${DATE} >> ${ELIG_LOG}/${LOG_NAME}
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

echo
echo "--> Moving files"
move_files

echo
echo "--> Creating and printing listing"
create_listing

exit 0
