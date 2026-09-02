#!/bin/ksh
#
# Program Name  : phnet04.sh
# Description   : CHANGE REIMBURSEMENT RATE FOR A NETWORK/CHAIN
# Author        : Christina Harris
# Date          : 11/24/97
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
PRINT_DIR=/usr/lnk/po/misc
STATE_FLAG=0
TIME=`date +%T`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet04.sh -a ["username"] -s

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


# Submit phnet04 program
submit_phnet04()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/phnet04 -s ${STATE_FLAG} -a ${USER}'            '

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
FG4AUD=/usr/lnk/audit/PHAAUD
export FG4AUD 

# Assign alternate environment variables
date
submit_phnet04
date

exit 0
