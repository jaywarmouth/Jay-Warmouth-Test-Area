#!/bin/sh
#
# Program Name  : restack13.sh
# Description   : Create DMR reports: Over Payment, Under Payment, Zero Payment
#                 Command line arguments:
#		  -d <restack date - ccyymmdd>
#                 -f <filename>  - alternate path and filename of input DMR text file. By default file is assigned as /usr/lnk/tmp/RESTACK12-DMR-<restack date>hhmmss.txt
# Author        : Peggy Voytilla
# Date          : 02/13/2014
# Modifications : 03/17/2014 - Fixed issue with emailing.
#               : 01/22/2015 - replaced cthornton@pdmi.com with diozzi@pdmi.com (TT:4805-9)(DME)
#		: 01/23/2015 - Correct Script by adding a date variable for current date. (TT:4805-9)(DME)
#               : 01/29/2015 - add coding to copy restack files to husk. (TT:4905-9)(DME)
#		: 03/12/2015 - Replace invidual emails with restack@pdmi.com
#
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
DMR_FILE="null"
DATETM=`date +%Y%m%d%H%M%S`
RSTK_DATE="null"
MAIL_PROG="/usr/bin/mutt"
FILE_FLG=0
RSTK_DATE=`date +%Y%m%d`
TMP_DIR="/usr/lnk/tmp"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: restack13.sh [-d <restack date(yymmdd)>] [-f <filename>]
	use the -d or -f option
	restack date input is required unless using -f option

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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do  
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RSTK_DATE=$1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi 
        INPUT_FILE=$1
        ;;
  esac
  shift
done

if [ $RSTK_DATE = "null" ]
then
	usage
	exit 1
fi

#Parse environment variables
parse_env

# Assign alternate environment variables
if [ $FILE_FLG = 1 ]
then
	DMRFILE=${INPUT_FILE}
else
	DMRFILE=`ls -1 ${TMP_DIR}/RESTACK12-DMR-${RSTK_DATE}??????.txt`
fi
if test -s ${DMRFILE}
then
	export DMRFILE
else
	echo "${DMRFILE} does not exist..."
	exit 1
fi

OVERFILE=${TMP_DIR}/RESTACK13_OVER_PAY_${DATETM}.csv
 export OVERFILE

UNDERFILE=${TMP_DIR}/RESTACK13_UNDER_PAY_${DATETM}.csv
 export UNDERFILE

ZEROFILE=${TMP_DIR}/RESTACK13_ZERO_PAY_${DATETM}.csv
 export ZEROFILE

echo Create DMR over, under and zero reports
date
echo "EXPORT PATHS:"
echo "   DMRFILE=$DMRFILE"
echo "   OVERFILE=$OVERFILE"
echo "   UNDERFILE=$UNDERFILE"
echo "   ZEROFILE=$ZEROFILE"

runcobol ${OBJ_DIR}/restack13

date

echo "Restack13 files are attached." | ${MAIL_PROG} -s "Restack13 Files" -a ${OVERFILE} -a ${UNDERFILE} -a ${ZEROFILE} -c operations@pdmi.com restack@pdmi.com

scp ${TMP_DIR}/RESTACK13_* husk:/usr/lnk/shares/ftp-tmp/restack

exit 0


