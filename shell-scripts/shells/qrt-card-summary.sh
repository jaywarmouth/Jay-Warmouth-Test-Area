#!/bin/ksh
#
# Program Name	: qrt-card-summary.sh
# Description	: Runs all the indivudual claim114 scripts
#		  Command Line Arguments:
#		  -b <batch range>
#		  -d <date range - ccyymmddccyymmdd>
# Author	: Linda S. Jefferis
# Date		: 7-16-2001
# Modifications : 01/04/2002 - Added procedures for grp# 1080  (LSJ) 
#		: 10/13/2005 - Added '-b' and '-d' input arguments  (LSJ)
#		: 10/13/2005 - Eliminated all runs for 4590 and 1080 groups  (LSJ)
#		: 04/19/2006 - Added qrt- to rpt/claim114  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL="/usr/lnk/shell"
RPT="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"
BATCH="null"
DATE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: qrt-card-summary.sh -b <batch range> -d <date range>
	where <batch range> is calendar quarter batch range
	      <date range> is calendar quarter date range ccyymmddccyymmdd 

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
# Check command line validity, call usage if incorrect
if [ $# -lt 4 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        BATCH=$1
        ;;
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
#parse_env

${SHELL}/claim114.sh -d ${DATE} -b ${BATCH} -g 00000000010080000000000001008999 > ${RPT}/qrt-claim114 2>&1
mv ${MISC_DIR}/CLAIM114-RPT ${MISC_DIR}/CLAIM114-RPT.1008000

exit 0
