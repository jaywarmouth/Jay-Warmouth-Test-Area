#!/bin/ksh
#
# Program Name  : epres06.sh
# Description   : Load CAWRK00MAS For RXHUB.
#		  Command Line Arguments:
#                  -t Test Mode
#		   -f <filename> - directory and filename for CAWRK00MAS
# Author        : James Masluk
# Date          : 11/10/2009
# Modifications : 11/18/2009 - Added "-f" option
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
FILE_FLAG=0
EPRES_DIR="/usr/lnk/e-pres/batch"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: epres06.sh [-t] [-f <CAWRK00MAS filename>]

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


# Submit epres06 program
submit_epres06()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/epres06 -s ${TEST_MODE}
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
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

if [ $TEST_MODE = 1 ]
then 
        CAWRK00MAS=/usr/lnk/wrk/CAWRK00MAS-ep06
          export CAWRK00MAS
fi

if [ ${FILE_FLAG} = 1 ]
then
	CAWRK00MAS=$FILE
	export CAWRK00MAS
else
	CAWRK00MAS=${EPRES_DIR}/CAWRK-EPRES
	export CAWRK00MAS
fi

SYSTEMPARM=/usr/lnk/log/EPRES06_PARM.txt
export SYSTEMPARM

echo "Load CAWRK00MAS For RXHUB"
echo "     CAWRK00MAS=$CAWRK00MAS"
echo "     SYSTEMPARM=$SYSTEMPARM"
date
submit_epres06
date

exit 0
