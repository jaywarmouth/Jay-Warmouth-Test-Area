#!/bin/ksh
#
# Program Name  : phnet19.sh
# Description   : Pharmacy Network Load To Special Networks
# Command Line Arguements:
#                 -t test mode            
#                 -d term mode
#                 -f file input
#                 -p special load
#                 -q custom load
# Author        : Mike Paulus
# Date          : 09/20/06
# Modifications : 06/04/08   Add switch for file input.                         
#               : 08/20/08   Add swithes for special load and custom load.
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
ARGUMENT=""
TIME=`date +%T`
TEST_MODE=0
TERM_MODE=0
FILE_INPUT=0
SPEC_LOAD=0
CUST_LOAD=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet19.sh [-t test_mode] [-d term_mode] [-f "filename"] [-p "special_load"] [-q "custom_load"] -a ["username"] 

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


# Submit phnet19 program
submit_phnet19()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/phnet19 -s ${TEST_MODE}${TERM_MODE}${FILE_INPUT}${SPEC_LOAD}${CUST_LOAD} -a ${USER}'            '  

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
    -t) TEST_MODE=1
        ;;
    -d) TERM_MODE=1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_INPUT=1
        ARGUMENT=$1
        ;;
    -p) SPEC_LOAD=1
        ;;
    -q) CUST_LOAD=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
FG4AUD=/usr/lnk/audit/PHAAUD
export FG4AUD

 if [ ${FILE_INPUT} = 1 ]
    then
      NABPINPUT=${ARGUMENT}
      export NABPINPUT
 fi

date
submit_phnet19
date


exit 0
