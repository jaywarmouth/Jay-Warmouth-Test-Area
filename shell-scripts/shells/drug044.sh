#!/bin/ksh
#
# Program Name  : drug044.sh
# Description   : Medicaid NDC Search by Name
# Author        : James Masluk
# Date          : 03/11/03
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

usage: drug044.sh  -a ["userclass&username"]

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


# Submit drug044 program
submit_drug044()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/drug044 -a ${USERCLASS}${USER}'           ' 

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

date

submit_drug044
date

exit 0
