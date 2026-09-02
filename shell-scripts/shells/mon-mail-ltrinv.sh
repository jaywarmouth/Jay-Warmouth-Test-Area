#!/bin/ksh
#
# Program Name	: mon-mail-ltrinv.sh
# Description	: Script for emailing sys48/spo0287 Letter Invoice to Acct.
#		  Command Line Arguments:
#		  -p <m/e prefix> - 3 characters(e.g. C31)
# Author	: Linda S. Jefferis
# Date		: 04/19/2004
# Modifications : 08/02/2005 - Added spo0283 logic
#		: 10/26/2005 - Changes for Linux (LSJ)
#		: 01/09/2006 - Removed spo0287 (LSJ)
#		: 08/23/2006 - Changes for 4-digit system number  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po/sys0048/spo0283"
MAIL_PROG="/bin/mail"
MAIL_TO="bjbonner@pdmi.com"
PREFIX="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mon-mail-ltrinv.sh -p <m/e date prefix, e.g. C31>

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
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        PREFIX=$1
	FILE=${PREFIX}LTRINV
        ;;
esac
  shift
done

# Parse environment variables
#parse_env

cat ${PO_DIR}/${FILE} > /tmp/${FILE}
cat /tmp/${FILE} | ${MAIL_PROG} -s "Monthly Aultman Invoice" ${MAIL_TO}

exit 0
