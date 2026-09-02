#!/bin/ksh
#
# Program Name	: claim42.sh
# Description   : Report Writer for Physician Utilization Review
#                 Command line arguments:
#                 -s Single Page
#                 -x Top X Physicians
#                 -t Sponsor run only
# Author	: Dave Tucci
# Date		: 03/21/2000
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SINGLE_PAGE=0
TOP_X_PHYSICIANS=0
SPONSOR_RUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim42.sh [-s] [-x] [-t]

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

# Submit claim42 program
submit_claim42()
{
   runcobol ${OBJ_DIR}/claim42 -s ${SINGLE_PAGE}${TOP_X_PHYSICIANS}${SPONSOR_RUN}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SINGLE_PAGE=1
        ;;
    -x) TOP_X_PHYSICIANS=1
        ;;
    -t) SPONSOR_RUN=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

echo " CLAIM41MAS=$CLAIM41MAS"

echo Report Writer for Physician Utilization Review
date
submit_claim42 
date

exit 0
