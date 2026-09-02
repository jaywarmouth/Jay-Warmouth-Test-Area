#!/bin/sh
#
# Program Name	: email_accum01_file.sh
# Description	: Email accum01 output .csv file to Benefits
# Author	: Linda Jefferis
# Date		: 09/13/2015
# Modifications :  
#
# Variables Used:
MAIL_PROG=/usr/bin/mutt
MAIL_TO=benefits@pdmi.com

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage:  $0 clientID filename

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
	usage
fi
CLIENTID=$1
FILE=$2

echo "Accum01 output file for ClientID: ${CLIENTID}" | ${MAIL_PROG} -s "Accum01 File" ${MAIL_TO} -a ${FILE}

exit 0
