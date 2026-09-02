#!/bin/ksh
#
# Program Name  : gentb001.sh
# Description   : GPI Screen List
# Author        : David Tucci
# Date          : 10/22/98
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

usage: gentb001.sh -s

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



# Submit gentb001 program
submit_gentb001()
{
       if [ ${GENTABLE} = 1 ]
       then
        runcobol ${OBJ_DIR}/gentb001 -s 1 
       else
        runcobol ${OBJ_DIR}/gentb001 -s 0
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
    -s) GENTABLE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

date
submit_gentb001
date

exit 0
