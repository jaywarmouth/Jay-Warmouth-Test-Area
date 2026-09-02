#!/bin/ksh
#
# Program Name  : phnet02.sh
# Description   : Pharmacy Network Load
# Command Line Arguements:
#                 -p pricing only
#                 -h help desk            
# Author        : David Tucci
# Date          : 11/10/97
# Modifications : 03/18/2005 - Addition of '-h' option
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
PRICE_ONLY=0
HELP_DESK=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet02.sh [-p price_only] [-h help_desk] -a ["username"] 

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


# Submit phnet02 program
submit_phnet02()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/phnet02 -s ${PRICE_ONLY}${HELP_DESK} -a ${USER}'            '

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
    -p) PRICE_ONLY=1
        ;;
    -h) HELP_DESK=1
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
submit_phnet02
date

exit 0
