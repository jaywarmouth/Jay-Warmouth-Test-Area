#!/bin/sh
#
# Program Name	: unzip_835_files.sh
# Description	: 
#		  Command Line Arguments:
#		  -d <ccyymmdd> - p/e date
#		  -n <chain #> 
# Author	: Linda S. Jefferis
# Date		: 10/15/2007
# Modifications : 01/12/2011 - Changed input date format 
#		: 06/12/2023 - updated FILE_DIR and misc cleanup
#
# Variables Used:
RPTARCH="/usr/lnk/rptarch"
FILE_DIR="/usr/lnk/wt/oper-wt/X12"
DATE="null"
ZIP_PROG="/usr/bin/unzip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: unzip_835_files.sh [-d <p/e date(ccyymmdd)>] [-n <chain #>]

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
   exit 1
fi

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
    -n) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	CHAIN=$1
	;;
  esac
  shift
done


if [ ${DATE} = "null" ]
then
	usage
fi

cd ${RPTARCH}
${ZIP_PROG} -d ${FILE_DIR} chk/chk-tapes-${DATE}.zip "*${CHAIN}*"

exit 0
