#!/bin/sh
#
# Program Name	: ncpdp_file_transfer.sh
# Description	: Rename and Transfer specified file to appropriate clientfiles area
#                 Command Line arguments:
#		  -f Full file process flag
# Author	: Linda S. Jefferis
# Date		: 06/06/2010
# Modifications : 07/31/2013 - fix for MAIL_TEXT issue
#		: 08/30/2013 - changed "mv ${FNAME}.gz" to "cp ${FNAME}.gz"
#		: 03/30/2017 - TT17093-2; add FULL logic.
#		: 05/01/2017 - Remove mpaulus@pdmi.com
#		: 11/29/2017 - TT:13915-52; change for weekly procedures.
#		: 12/21/2017 - TT:13915-58; correct file date and removal of different names for full file switch. Also removed TEST option and logic.
#		: 01/31/2020 - TT:13915-86
#		: 04/28/2020 - Update emailing procedure
#		: 11/3/2023 - Removed datasupport@pdmi.com email address
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SQL_DIR="/usr/lnk/wt/sqlimports"
DATE=`date +%Y%m%d`
ZIP_PROG="/bin/gzip"
MAIL_PROG=/usr/bin/mutt
MAIL_TO="operations@pdmi.com"
TR_ERR=0
FULL=0
NCP_OUT[1]="NCPTP20TAP"
NCP_OUT[2]="NCPPR00TAP"
NCP_OUT[3]="NCPTX00TAP"
NCP_OUT[4]="NCPRD00TAP"
NCP_OUT[5]="NCPMED0TAP"
NCP_OUT[6]="NCPPA20TAP"
NCP_OUT[7]="NCPPO00TAP"
NCP_OUT[8]="NCPEPR0TAP"
NCP_OUT[9]="NC3CO00TAP"
NCP_OUT[10]="NC3RR00TAP"
NCP_OUT[11]="NC3SL00TAP"
NCP_OUT[12]="NC3SI00TAP"
NCP_OUT[13]="NCPTP00NEW"
MAXFILES=13
PHARM_DIR="/usr/upd/pharm"
MAIL_TEXT=${PHARM_DIR}/email-log.txt
TEMP_LOG=/tmp/ncpdpfilelist.txt
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ncpdp_file_transfer.sh

ENDOFUSAGE
  exit 1
}

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
# Transfer file
file_transfer()
{
if test -e ${FNAME}
then
        ${ZIP_PROG} ${FNAME}
        cp ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "${FNAME} not copied"
                TR_ERR=1
	else
		rm -f ${FNAME}.gz
        fi
else
        echo "${FNAME} does not exist"
fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) FULL=1
        ;;
  esac
  shift
done

parse_env

i=1
while [ $i -le ${MAXFILES} ]
do
	cp ${PHARM_DIR}/${NCP_OUT[i]} ${PHARM_DIR}/${NCP_OUT[i]}-${DATE}
	echo "${NCP_OUT[i]}-${DATE}" >> ${TEMP_LOG}
	FNAME=${PHARM_DIR}/${NCP_OUT[i]}-${DATE}
	OUT_DIR="NCPDPWEEKLY"
	file_transfer
	let i=i+1
done

if [ $TR_ERR = 0 ]
then
	echo "" > ${MAIL_TEXT}
	echo "Pharmacy has completed all their NCPDP processing/updating/validating." >> ${MAIL_TEXT}
	echo "" >> ${MAIL_TEXT}
	cat ${TEMP_LOG} >> ${MAIL_TEXT}
	${MAIL_PROG} -s "NCPDP Notification" ${MAIL_TO} < ${MAIL_TEXT}
	rm -f ${MAIL_TEXT} ${TEMP_LOG}
else
	echo "One or more of the pharmacy completed NCPDP file transfers/copies failed..." | ${MAIL_PROG} -s "NCPDP Notification" operations@pdmi.com
	RETVAL=99
fi

exit $RETVAL
