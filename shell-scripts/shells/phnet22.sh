#!/bin/sh
#
# Program Name  : phnet22.sh
# Description   : Pharmacy Network Load To Special Networks
# Command Line Arguements:
#                 -t test mode            
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
TEST_MODE=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: phnet22.sh [-t test_mode]  

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


# Submit phnet22 program
submit_phnet22()
{
        runcobol ${OBJ_DIR}/phnet22 -s ${TEST_MODE}  
	RETVAL=$?
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
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
FG4AUD=${PHAAUD}
export FG4AUD


date
submit_phnet22
date


exit ${RETVAL}
