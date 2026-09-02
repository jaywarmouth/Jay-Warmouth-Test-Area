#!/bin/sh
#
# Program Name  : gentb08.sh
# Description   : GPI Screen List
# Author        : Janice Lanzo
# Date          : 03/11/2021
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
USERCLASS=""
GENTABLE=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: gentb08.sh -s

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



# Submit gentb08 program
submit_gentb08()
{
        runcobol ${OBJ_DIR}/gentb08 -s ${GENTABLE} 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) GENTABLE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

date
submit_gentb08
date

exit 0
