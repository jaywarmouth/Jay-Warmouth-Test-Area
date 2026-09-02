#!/bin/ksh
#
# Program Name	: ccpi_lst.sh
# Description	: Creates log listing of CCPI(sys50) eligibility file.
#                 Command Line Arguments:
#                 -d <mmdd> - date of file.
# Author	: Linda S. Jefferis
# Date		: 02/03/2005
# Modifications : 
#               : 06/13/2005 - Changes for doing email of listing instead of printing for Benefits
#		: 10/26/2005 - Changes for Linux  (LSJ)
#		: 05/30/2006 - changed HOME_DIR from uhmo-wt to ccpi-wt  (LSJ)
#		: 06/05/2006 - Eliminated unzip process  (LSJ)
#		: 08/22/2006 - Changes for 4-digit system number  (LSJ)
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
SYS="sys0050"
HOME_DIR="/usr/lnk/wt/ccpi-wt"
ZIP_FILE="CCPI_*.zip"
CCPI_ELIG="CCPI_Members.dat"
CCPI_GRP="CCPI_Groups.dat"
CCPI_FLG=0
UNZIP_PROG="/usr/bin/unzip"
MAIL_PROG="/bin/mail"
MAIL_TO="benefits@pdmi.com operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ccpi_lst.sh [-d <mmdd>]

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
	${UNZIP_PROG} -jLn -d ${HOME_DIR} ${HOME_DIR}/${ZIP_FILE}
	mv ${HOME_DIR}/${ZIP_FILE} ${ELIG_ARCH}/${SYS}
}

#
# Move files
mv_files()
{
	mv ${HOME_DIR}/${IN_FILE} ${ELIG_DIR}/${OUT_FILE}${DATE}
	cp ${ELIG_DIR}/${OUT_FILE}${DATE} ${ELIG_ARCH}
}

#
# Ulticare files
ultc_files()
{
	if test -a ${HOME_DIR}/${CCPI_ELIG}
	then
	   CCPI_FLG=1
	   IN_FILE=${CCPI_ELIG}
	   OUT_FILE="uce"
	   mv_files
	else
	   echo "-*> ${HOME_DIR}/${CCPI_ELIG} does not exist..."
	fi
	if test -a ${HOME_DIR}/${CCPI_GRP}
	then
	   CCPI_FLG=1
	   IN_FILE=${CCPI_GRP}
	   OUT_FILE="ucg"
	   mv_files
	else
	   echo "-*> ${HOME_DIR}/${CCPI_GRP} does not exist..."
	fi
}

#
# Create Log listing
log_lst()
{
	cd ${ELIG_DIR}
	echo "${CLIENT_NAME} Eligibility Files" > ${ELIG_LOG}/${LOG_NAME}
	echo "-------------------------------------" >> ${ELIG_LOG}/${LOG_NAME}
	echo "" >> ${ELIG_LOG}/${LOG_NAME}
	ls -l ${PREFIX}?${DATE} >> ${ELIG_LOG}/${LOG_NAME}
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
echo "--> Checking for Ulticare files"
echo
ultc_files

echo
echo "--> Creating log listings"
echo

if [ ${CCPI_FLG} = 1 ]
then
   CLIENT_NAME="Community Care Partners (sys50)"
   LOG_NAME="ccpi${DATE}.log"
   PREFIX="uc"
   log_lst
fi

# Parse environment variables
#parse_env

exit 0
