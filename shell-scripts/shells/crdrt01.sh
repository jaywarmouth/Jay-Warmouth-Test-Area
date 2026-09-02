#!/bin/ksh
#
# Program Name  : crdrt01.sh
# Description   : Real Time ID Card Order Program 
#		  Command Line Arguments:
#                 -l Line Number
#                 -t Test Mode (Demo)
#
# Author        : James Masluk
# Date          : 06/24/11
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

usage: crdrt01.sh [-t] [-l <line number>] 
        -l line numbers            queue numbers for real time processing.

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

#
# Submit crdrt01 program
submit_crdrt01()
{
   runcobol ${OBJ_DIR}/crdrt01 -s ${TEST_MODE} -a ${LINE_NUM}
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
FG4AUD=/usr/lnk/audit/CRDAUD-RT
export FG4AUD

umask 111

echo "ID Card Order Program"
date
submit_crdrt01 
date

exit 0
