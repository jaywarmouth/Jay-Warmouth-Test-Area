#!/bin/ksh
#
# Program Name	: conv_phys340b_rpts.sh
# Description	: Convert specified phys340 file to PDF and email
# Author	: Linda S. Jefferis
# Date		: 09/17/2012
#
# Variables Used:
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="Group340B@pdmi.com"
MAIL_CC="operations@pdmi.com"
MAIL_SUBJ="340b Physician Report"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: conv_phys340b_rpts.sh <report name> 
	where <report name> includes full directory name

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 1 ]
then
   usage
fi

FILE=$1

if test -s ${FILE}
then
	a2ps -1l132 -o - ${FILE} | ps2pdf - ${FILE}.pdf
	if test $? -ne 0
	then
		echo "-*> Problem with conversion of ${FILE}..."
		exit 1
	fi
	echo "340b Physician Report is attached." | ${MAIL_PROG} -a ${FILE}.pdf -s "${MAIL_SUBJ}" -c ${MAIL_CC} ${MAIL_TO}
else
	echo "--*> The file ${FILE} does not exist."
fi

exit 0
