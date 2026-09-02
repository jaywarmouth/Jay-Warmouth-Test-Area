#!/bin/ksh
#
# Program Name  : pharm05.sh
# Description   : Pharmacy Demographic Extract For Universal RX.
#		  Command Line Arguments:
#                 -s Skip sort flag
#                 -t Test Mode                 
# Author        : Mike Paulus
# Date          : 05/16/05
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj 
SKIP_SORT=0
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pharm05.sh [-s] [-t]

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


# Submit pharm05 program
submit_pharm05()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/pharm05 -s ${SKIP_SORT}${TEST_MODE} 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SKIP_SORT=1
        ;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${TEST_MODE} = 1 ]
then

   PHARM05KEY=/usr/lnk/wrk/PHARM05KEY
     export PHARM05KEY  
fi

echo "Pharmacy Demogrhapic Extract for Universal RX"
date
submit_pharm05
date

exit 0
