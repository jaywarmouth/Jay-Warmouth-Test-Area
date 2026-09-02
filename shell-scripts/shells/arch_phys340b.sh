#!/bin/ksh
#
# Program Name	: arch_phys340b.sh
# Description	: Archive specified files
# Author	: Linda S. Jefferis
# Date		: 09/17/2012
#
#Modifications	: 5/1/2013 - Add logic to archive into a year directory (DME)
#
# Variables Used:
ARCH_DIR="/usr/lnk/elig_in_1/340b"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: arch_phys340b.sh <file name> <file date> 
	where <file name> includes full directory name
	<file name> can include wildcard references
	and <file date> is date provided on file

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
DATE=$2
YEAR=`echo ${DATE} |cut -c1-4`
#echo $FILE

if test -s ${FILE}
then
	echo "--> Moving ${FILE} to ${ARCH_DIR}/${YEAR}"
	mv ${FILE} ${ARCH_DIR}/${YEAR}
	if test $? -ne 0
	then
		echo "-*> Problem with copying ${FILE}..."
		echo "-*> Fix before running additional 340b Physician Processes"
		exit 1
	else
		echo "--> Removing ${FILE}.pdf"
		rm -f ${FILE}.pdf
	fi
else
	echo "--*> The file ${FILE} does not exist."
fi

exit 0
