#!/bin/ksh
#
# Program Name	: ccai_lst.sh
# Description	: Creates log listing of CCAI(sys106) eligibility file.
#                 Command Line Arguments:
#                 -d <mmdd> - date of file.
# Author	: Linda S. Jefferis
# Date		: 12/19/2007
# Modifications : 06/30/2009 - Changes (added 'sed') to handle mixed case of files
#		: 11/11/2009 - Added ToPDMI sub-directory
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE="null"
ELIG_DIR=/usr/lnk/elig_in
ELIG_LOG=/usr/lnk/elig_in/logs
ELIG_ARCH=/usr/lnk/elig_in_1
SYS="sys0106"
CLIENT="ca"
CLIENT_DESCR="Community Care Associates (sys106)"
HOME_DIR="/usr/lnk/wt/ccai-wt/ToPDMI"
ZIP_FILE="CCAI_*.zip"
CCAI_ELIG="ccai_members.dat"
CCAI_GRP="ccai_groups.dat"
CCAI_FLG=0
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ccai_lst.sh [-d <mmdd>]

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
# Unzip files
unzip_file()
{
	${UNZIP_PROG} -j -d ${ELIG_DIR} ${HOME_DIR}/${ZIP_FILE}
	mv ${HOME_DIR}/${ZIP_FILE} ${ELIG_ARCH}/${SYS}
	cd ${ELIG_DIR}
	for FILE in `ls CCAI*.dat`
   	do
        	FILE_CAP=`echo $FILE | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
        	mv $FILE $FILE_CAP
   	done
}

#
# Move files
mv_files()
{
	if test -a ${ELIG_DIR}/${CCAI_ELIG}
        then
		mv ${ELIG_DIR}/${CCAI_ELIG} ${ELIG_DIR}/${CLIENT}e${DATE}
	else
           	echo "-*> ${ELIG_DIR}/${CCAI_ELIG} does not exist..."
		#echo "-*> This script is exiting before completion."
		#exit 1
	fi
	if test -a ${ELIG_DIR}/${CCAI_GRP}
	then
		mv ${ELIG_DIR}/${CCAI_GRP} ${ELIG_DIR}/${CLIENT}g${DATE}
	else
		echo "-*> ${ELIG_DIR}/${CCAI_GRP} does not exist..."
		#echo "-*> This script is exiting before completion."
		#exit 1
	fi
	cp ${ELIG_DIR}/${CLIENT}?${DATE} ${ELIG_ARCH}
}


#
# Create Log listing
log_lst()
{
	cd ${ELIG_DIR}
	LOG_NAME="ccai${DATE}.log"
	echo "${CLIENT_DESCR} Eligibility Files" > ${ELIG_LOG}/${LOG_NAME}
	echo "-------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
	echo "" >> ${ELIG_LOG}/${LOG_NAME}
	ls -l ${CLIENT}?${DATE} >> ${ELIG_LOG}/${LOG_NAME}
	cat ${ELIG_LOG}/${LOG_NAME} | ${MAIL_PROG} -s "ELIGIBILITY LISTING" ${MAIL_TO}
}

#
#
# Main routine
#
# Check command line validity, call usage if incorrect
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
  esac
  shift
done

if [ ${DATE} = "null" ]
then
   usage
fi

echo
echo "--> Unzipping"
echo
unzip_file

echo
echo "--> Move files"
echo
mv_files

echo
echo "--> Creating log listings"
echo
log_lst

# Parse environment variables
#parse_env

exit 0
