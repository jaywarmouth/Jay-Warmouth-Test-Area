#!/bin/ksh
#
# Program Name	: limit22.sh
# Description   : Recalculate Limits by Group
#                 Command line arguments:
#                 -g Recalculate Group
#                 -p Recalculate Previous Period
#                 -o One Claims File
# Author	: Christina M. Senediak
# Date		: 12/18/96
# Modifications : 06/19/97 LSJ  Added env_var & OBJ_DIR logic
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
GROUP=0
PREVIOUS_PERIOD=0
ONE_CLAIMS_FILE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit22.sh [-s] 

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


# Submit limit22 program
submit_limit22()
{
   if [ ${ONE_CLAIMS_FILE} = 1 ]
     then
        runcobol ${OBJ_DIR}/limit22 -s ${GROUP}${PREVIOUS_PERIOD}1
     else
        runcobol ${OBJ_DIR}/limit22 -s ${GROUP}${PREVIOUS_PERIOD}0
   fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -g) GROUP=1     
        ;;
    -p) PREVIOUS_PERIOD=1
        ;;
    -o) ONE_CLAIMS_FILE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

echo Cardholder Limit Report
date
submit_limit22 
date

exit 0
