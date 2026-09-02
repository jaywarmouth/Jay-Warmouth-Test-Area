#!/bin/ksh
#
# Program Name  : phnet13.sh
# Description   : Pharmacy Network Termination
# Author        : David Tucci
# Date          : 11/10/99
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
PRINT_DIR=/usr/lnk/po/misc
USER=""
TIME=`date +%T`
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet13.sh -a ["username"] 

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


# Submit phnet13 program
submit_phnet13()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/phnet13 -a ${USER}'            '

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
        USER=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
FG4AUD=/usr/lnk/audit/PHAAUD
export FG4AUD

echo "  PHNET00MAS=$PHNET00MAS"


date
submit_phnet13
date

exit 0
