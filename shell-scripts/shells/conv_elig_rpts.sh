#!/bin/sh
#
# Program Name	: conv_elig_rpts.sh
# Description	: Convert specified eligibility file to PDF
# Author	: Linda S. Jefferis
# Date		: 04/20/2009
# Modifications : 10/21/2009 - Added remote chmod command
#		: 01/24/2019 - updated a2ps command to handle "non-printable" characters.
#		: 10/31/2019 - Switch from a2ps to enscript
#		: 11/11/2019 - adjust font size to eliminate page overflow (dme)
#		: 06/22/2020 - Add "test" logic.
#		: 3/1/2022 - eliminate logic for Husk:/usr/lnk/shares/ftp-tmp/Benefits/Elig
# Variables Used:
DTETM=`date +%Y%m%d-%H%M%S`
TEST_FLG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: conv_elig_rpts.sh <report name> <local directory> test
	The PDF file, by default, is written to:
		/usr/lnk/wt/oper-wt/EligReports
	If use optional "test", the PDF file is written to:
		/usr/lnk/wt/oper-wt/EligReports-Test

ENDOFUSAGE
  exit 99
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
fi
if [ $# -eq 3 ]
then
	TEST_FLG=$3
fi

FILE=$1
LOCAL_DIR=$2

if [ $TEST_FLG = "test" ]
then
	WT_DIR="/usr/lnk/wt/oper-wt/EligReports-Test"
else
	WT_DIR="/usr/lnk/wt/oper-wt/EligReports"
fi

if test -s ${LOCAL_DIR}/${FILE}
then
	enscript -rlg -f Courier7 --non-printable-format=space -o - ${LOCAL_DIR}/${FILE} | ps2pdf - ${LOCAL_DIR}/${FILE}.pdf
	if test $? -ne 0
	then
		echo "-*> Problem with conversion of ${FILE}..."
		exit 99
	fi
	cp ${LOCAL_DIR}/${FILE}.pdf ${WT_DIR}/${DTETM}-${FILE}.pdf
	if test $? -eq 0
	then
		rm -f ${LOCAL_DIR}/${FILE}.pdf
	else
		echo "-*> Problem with copying ${LOCAL_DIR}/${FILE}.pdf..."
		echo "-*> Fix before running additional elig_process.sh"
		exit 99
	fi
else
	echo "--*> The file ${LOCAL_DIR}/${FILE} does not exist."
fi

exit 0
