#!/bin/ksh
#
# Program Name  : phnet14.sh
# Description   : NABP Group Network Search
#		  Command Line Arguments:
#                 -a <userclass> <username>
#		  -z Demo run flag
# Author        : David Tucci
# Date          : 11/22/99
# Modifications : 12/29/1999 - Added Demo flag option logic  (LSJ)
#               : 12/07/2000 - Added userclass (DW)
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
USERCLASS=""
TIME=`date +%T`
DEMO=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet14.sh -a ["userclass&username"] [-z]

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


# Submit phnet14 program
submit_phnet14()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/phnet14 -a ${USERCLASS}${USER}'            '

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
    -z) DEMO=1
	;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${DEMO} = 1 ]
then
   ENV_FILE=/usr/lnk/demo/env_var.demo
   parse_env
fi

date
submit_phnet14
date

exit 0
