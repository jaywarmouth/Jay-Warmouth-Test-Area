#!/bin/ksh
#
# Program Name  : gralt01.sh
# Description   : Alternate & PDM group list 
# Author        : David Tucci
# Date          : 03/12/97
# Modifications : 07/17/97 KK Update to shell standards. 
#                 09/02/97 CH Add permissions in. 
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
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: gralt01.sh

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



# Submit gralt01 program
submit_gralt01()
{
        runcobol ${OBJ_DIR}/gralt01 -a ${USERCLASS}${USER}'            '

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -a) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USERCLASS=$1
        USER=$2
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Alternate & PDM group listing"
date
submit_gralt01
date

exit 0
