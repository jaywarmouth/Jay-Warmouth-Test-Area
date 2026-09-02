#!/bin/ksh
#
# Program Name  : formulary73.sh
# Description   : Formulary Drug Search by GPI
#                 Command line arguments:
#                 -l Line Number
#                 -t Test Mode
#  
# Author        : Mike Paulus    
# Date          : 08/06/09
# Modifications :  
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
LINE_NUM=000
TEST_MODE=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: formulary73.sh [-t] [-l <line number>]

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


# Submit formulary73 program
submit_formulary73()
{
        runcobol ${OBJ_DIR}/formulary73 -s ${TEST_MODE} -a ${LINE_NUM}  

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

date
submit_formulary73
date

exit 0
