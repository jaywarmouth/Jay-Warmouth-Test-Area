#!/bin/sh
#
# Program Name	: img_lst.sh
# Description	: Moves files and creates log listing of URX/IMG eligibility file.
#                 Command Line Arguments:
#                 -d <ccyymmdd> - date on file sent.
# Author	: Linda S. Jefferis
# Date		: 04/05/2002
# Modifications : 12/18/2002 - Added logic for possible .des file  (LSJ)
#		: 01/14/2003 - Added logic for second file with in zip file.
#		: 03/04/2003 - Added logic for third (ns) file  (LSJ)
#               : 06/13/2005 - Changes for doing email of listing instead of printing for Benefits
#		: 10/26/2005 - Changes for Linux  (LSJ)
#		: 08/16/2006 - Added check if INPUT_DATE=null  (LSJ)
#		: 08/22/2006 - Changes for 4-digit system number  (LSJ)
#		: 11/11/2009 - Added ToPDMI sub-directory
#		: 04/30/2010 - Added logic for new accum file
#		: 03/04/2014 - Change img-wt to img-ftps
#		: 12/17/2014 - Added coding for Encrypted file (DME)
#		: 01/07/2015 - Correct coding errors for file removal
#		: 01/26/2022 - removing decryption and change REMOTE_DIR to accomdate the files coming in through SFTP (DME)#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
INPUT_DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_LOG=/usr/lnk/elig_in/logs
ELIG_ARCH="/usr/lnk/elig_in_1"
SYS_DIR="sys0058"
BUCKET_NAME="ga-internal-transfers"
FILE_PATH="URX/IMG/INBOUND/Elig"
REMOTE_DIR="$BUCKET_NAME/$FILE_PATH"
AWS_MV="/usr/local/bin/aws s3 mv"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
REMOTE_DIR="/usr/lnk/wt/oper-wt/elig/URXIMG/ToPDMI"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: img_lst.sh [-d <ccyymmdd>]

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
        DATE=`echo ${INPUT_DATE} | cut -c5-8`
}

#
# Set Filenames
set_filename()
{
	ELIG_FILE="img_urx_${INPUT_DATE}.txt"
	ACCUM_FILE="img_${INPUT_DATE}_accum.txt"
	ZIP_FILE="IMG_URX_${INPUT_DATE}.zip"
}

#
#aws_move
aws_move()
{
        if aws s3api head-object --bucket "$BUCKET_NAME" --key "$FILE_PATH/$ZIP_FILE" > /dev/null 2>&1
        then
		/usr/local/bin/aws s3 mv s3://ga-internal-transfers/URX/IMG/INBOUND/Elig/${ZIP_FILE} ${ELIG_DIR}/${ZIP_FILE}
#          cp ${ELIG_DIR}/${ZIP_FILE} ${ELIG_ARCH}/${SYS_DIR}
        else
          echo "-*> Incorrect elig. filename...exiting process"
          exit 1
        fi
}

	

#
#Unzip File
unzip_file()
{
   ${UNZIP_PROG} -jL ${ELIG_DIR}/${ZIP_FILE} -d ${ELIG_DIR}
}

#
#Move File
move_file()
{
if test -s ${ELIG_DIR}/${ELIG_FILE}
then
	mv ${ELIG_DIR}/${ELIG_FILE} ${ELIG_DIR}/ige${DATE}
	cp ${ELIG_DIR}/ige${DATE} ${ELIG_ARCH}
else
	echo "*-> The IMG ELIG File, ${ELIG_FILE}, does not exist or is zero."
	exit 99
fi
if test -s ${ELIG_DIR}/${ACCUM_FILE}
then
	mv ${ELIG_DIR}/${ACCUM_FILE} ${ELIG_DIR}/igl${DATE}
	cp ${ELIG_DIR}/igl${DATE} ${ELIG_ARCH}
else
	echo "*-> The IMG ACCUM File, ${ACCUM_FILE}, does not exist or is zero."
	exit 99
fi

}

#
#Create listing
create_listing()
{
LOG_NAME=img-${DATE}.log
cd ${ELIG_DIR}
echo "URX/IMG Eligibility and Accumulator Files" > ${ELIG_LOG}/${LOG_NAME}
echo "----------------------------" >> ${ELIG_LOG}/${LOG_NAME}
echo "" >> ${ELIG_LOG}/${LOG_NAME}
ls -l ig?${DATE} >> ${ELIG_LOG}/${LOG_NAME}


cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}

}

#
# Cleanup
cleanup()
{
	rm -f ${REMOTE_DIR}/${ZIP_FILE}
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

echo "--> moving zip file from aws"
aws_move

echo "--> unzipping File"
unzip_file

echo ""
echo "--> Moving files"
move_file


echo ""
echo "--> Creating Listing"
create_listing
cleanup

exit 0
