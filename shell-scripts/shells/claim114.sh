#!/bin/ksh
#
# Program Name	: claim114.sh
# Description   : PRM Cardholder Summary
#                 Command line arguments:
#                 -s Skip sort flag
#                 -c Sort By Cardholder Name
#                 -d Date Range
#                 -b Batch Range
#                 -g Group Range
# Author	: Dave Tucci
# Date		: 11/16/99
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SKIP_SORT=0
BATCH="null"
CARD_SORT=0
SYS_NBR=0001
DATE_RANGE="null"
GROUP_RANGE="null"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim114.sh [-s] [-c] [-d <CCYYMMDCCYYMMDD>] [-b <batchrange>] [-g <grouprange>]

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Submit claim114 program
submit_claim114()
{
      runcobol ${OBJ_DIR}/claim114 -s ${SKIP_SORT}${CARD_SORT} -a ${DATE_RANGE}${BATCH_RANGE}${GROUP_RANGE}${SYS_NBR}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SKIP_SORT=1
        ;;
    -c) CARD_SORT=1
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE_RANGE=$1
        ;;
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        BATCH_RANGE=$1
        ;;
    -g) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        GROUP_RANGE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
echo "PRM Cardholder Summary - CLAIM114"
date
echo "EXPORT PATHS:"
submit_claim114 
date

exit 0
