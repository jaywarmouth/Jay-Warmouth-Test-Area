#!/bin/sh
#
# Program Name	: mthly_keybank.sh
# Description	: Runs the check01 procedure that updates the monthly KeyBank Reconciliation file.
#		  Command Line Arguments:
#		  -d <mmyy> - month and year of arp filename
# Author	: Linda S. Jefferis
# Date		: 06/20/2002
# Modifications : 01/10/2007 - Changed lp to email  (LSJ)
#		: 03/12/2007 - Removed display about printing report and changed email to computers  (LSJ)
#		: 10/19/2021 - Changed FILE_DIR and added ARCH_DIR logic.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
USER_NAME=`/usr/bin/logname`
FILE_PREFIX="arp-"
DATE="null"
FILE_DIR="/usr/lnk/wt/oper-wt/KeyBank/Monthly"
ARCH_DIR="/usr/lnk/keybank"
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG=/bin/mail
MAIL_TO="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mthly_keybank.sh [-d <mmyy>]
	where <mmyy> is the date assigned to the "arp" file.

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

# Parse environment variables
parse_env

if test -s ${FILE_DIR}/${FILE_PREFIX}${DATE}
then
	echo
	echo "RECORD COUNT:  `wc -l ${FILE_DIR}/${FILE_PREFIX}${DATE}`"
	${SHELL_DIR}/check01.sh -f ${FILE_DIR}/${FILE_PREFIX}${DATE} -a ${USER_NAME} > ${RPT_DIR}/check01 2>&1
	echo
	echo "--> Verify totals on emailed report against the above displayed record count."
	cat ${RPT_DIR}/check01 | ${MAIL_PROG} -s "Monthly KeyBank Update" ${MAIL_TO}
	mv ${FILE_DIR}/${FILE_PREFIX}${DATE} ${ARCH_DIR}
	find ${ARCH_DIR} -follow -name "arp-*" -mtime +365 -exec rm {} \;
else
	echo
	echo "--*> The file, ${FILE_DIR}/${FILE_PREFIX}${DATE} does not exist."
	echo "--*> Process is being cancelled..."
	exit 1
fi

exit 0
