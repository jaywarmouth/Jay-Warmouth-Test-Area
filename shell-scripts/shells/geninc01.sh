#!/bin/ksh
#
# Program Name  : geninc01.sh
# Description   : Warehouse GENINC0MAS File Extract
#                 Exports whole file
# Author        : Linda Jefferis
# Date          : 02/08/2010
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

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: geninc01.sh

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


# Submit geninc01 program
submit_geninc01()
{
        runcobol ${OBJ_DIR}/geninc01

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
     *) usage
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

date
submit_geninc01
date

exit 0
