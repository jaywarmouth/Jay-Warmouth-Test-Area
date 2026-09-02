#!/bin/ksh
#
# Program Name  : limit12.sh
# Description   : Limit EOB Letters                 
#                 Command line arguments:
#                 -m Sponsor 283 run
# Author        : Debbie Wilson     
# Date          : 10/11/00
# Modifications : 07/11/2005 - Addition of sponsor #283 run
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
SPO283_RUN=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit12.sh [-m spo283_run]

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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


# Submit limit12 program
submit_limit12()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/limit12 -s ${SPO283_RUN}

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -m) SPO283_RUN=1  
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

date
submit_limit12
date

exit 0
