#!/bin/ksh
#
# Program Name	: limit01.sh
# Description   : SELECT CARDHOLDER LIMIT SUMMARY
#                 Command line arguments:
#                 -g <group range> Note: Each group number must be 16 digits:total 32 digits.
# Author	: David Tucci
# Date		: 12/13/99
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
GROUP_RANGE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit01.sh [-g <group range>]

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


# Submit limit01 program
submit_limit01()
{
        runcobol ${OBJ_DIR}/limit01 -a ${GROUP_RANGE}
 
}

#
# Main routine
#

#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
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

date
submit_limit01 
date

exit 0
