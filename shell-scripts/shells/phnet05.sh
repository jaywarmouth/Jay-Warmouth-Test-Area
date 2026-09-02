#!/bin/ksh
#
# Program Name  : phnet05.sh
# Description   : Pharmacy Network Load
# Author        : Christina Harris
# Date          : 11/21/97
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
STATE_FLAG=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet05.sh -a ["username"] -s

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


# Submit phnet05 program
submit_phnet05()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/phnet05 -s ${STATE_FLAG} -a ${USER}'            '

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
    -s) STATE_FLAG=1 
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

FG4AUD=/usr/lnk/audit/PHAAUD
export FG4AUD

date
submit_phnet05
date

exit 0
