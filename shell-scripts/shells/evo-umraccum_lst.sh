#!/bin/sh
#
# Program Name	: evo-umraccum_lst.sh
# Description	: Moves files and creates log listing of EVO-UMR accum file.
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on file sent.
#
# Modifications : 08/26/2025 - adding coding for aws s3 buckets (DME)
#
#
#
# Variables Used:
INPUT_DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_LOG=/usr/lnk/elig_in/logs
ELIG_ARCH="/usr/lnk/elig_in_1"
BUCKET_NAME="ga-internal-transfers"
FILE_PATH="EVO/UMR/INBOUND/Accum"
REMOTE_DIR="$BUCKET_NAME/$FILE_PATH"
AWS_MV="/usr/local/bin/aws s3 mv"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
CLIENT="eu"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: evo-umraccum_lst.sh [-d <ccyymmdd>]

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
	ACCUM_FILE="EVOUMR_accum_${INPUT_DATE}.txt"
}

#
# Move Files
move_files()
{
        if aws s3api head-object --bucket "$BUCKET_NAME" --key "$FILE_PATH/$ACCUM_FILE" > /dev/null 2>&1
        then
          #${AWS_MV} 
	/usr/local/bin/aws s3 mv s3://${REMOTE_DIR}/${ACCUM_FILE} ${ELIG_DIR}/${CLIENT}l${DATE}
          cp ${ELIG_DIR}/${CLIENT}l${DATE} ${ELIG_ARCH}
        else
          echo "-*> Incorrect elig. filename...exiting process"
          exit 1
        fi
}

#
# Create Listing
create_listing()
{
        LOG_NAME=${CLIENT}l-${DATE}.log
        cd ${ELIG_DIR}
        echo "EVO-UMR (Sys0218) Accumulator File" > ${ELIG_LOG}/${LOG_NAME}
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
