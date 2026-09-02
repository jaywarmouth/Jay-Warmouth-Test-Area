#!/bin/ksh
#
# Program Name  : epres02.sh
# Description   : 270/271 Eligibility Request and Response
#		  Command Line Arguments:
#                 -l Line Number
#                 -t Test Mode (Demo)
#
# Author        : James Masluk
# Date          : 02/27/09
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
LINE_NUM=00
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: epres02.sh [-t] [-l <line number>]

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


# Submit epres02 program
submit_epres02()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/epres02 -s ${TEST_MODE} -a ${LINE_NUM}

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1
        ;;
    -l) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        LINE_NUM=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "270/271 Eligibility Request and Response"
date
submit_epres02 
date

exit 0
