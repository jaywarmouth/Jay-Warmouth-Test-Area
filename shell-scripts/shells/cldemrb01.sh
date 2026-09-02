#!/bin/ksh
#
# Program Name  : cldemrb01.sh
# Description   : Warehouse CLDEM00MAS File Extract
#		  Command Line Arguments:
#                 -b <Batch Range> - Batch run
#		  -o <file name> - assign alternate output file
# Author        : Bill Kohuth
# Date          : 03/22/13
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
BATCH_RUN=0
OUTPUT_FILE="null"
RERUN_INFO="null"
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cldemrb01.sh [-d] [-b <batch-range>]

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


# Submit cldemrb01 program
submit_cldemrb01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/cldemrb01 -s ${BATCH_RUN} -a ${RERUN_INFO}

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        OUTPUT_FILE=$1
        ;;
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	BATCH_RUN=1
	RERUN_INFO=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${FILE_FLAG} = 1 ]
then
        CLDEMRB001=${OUTPUT_FILE}
        export CLDEMRB001
fi

echo "CLDEM00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   CLDEM00MAS=${CLDEM00MAS}"
echo "   CLDEMRB001=${CLDEMRB001}"
echo "   BATCH RANGE = ${RERUN_INFO}"
submit_cldemrb01
date

exit 0
