#!/bin/sh
#
# Program Name  : clmsgrb01.sh
# Description   : Warehouse CLMSG00MAS File Extract
#		  Command Line Arguments:
#                 -b <Batch Range> - Alternate Batch run (default is previous day)
#		  -o <file name> - assign alternate output file
# Author        : Mike Paulus
# Date          : 03/15/12
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
OUTPUT_FILE="null"
RERUN_INFO="null"
BATCH_RUN=0
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clmsgrb01.sh [-d] [-b <batch-range>]

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


# Submit clmsgrb01 program
submit_clmsgrb01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/clmsgrb01 -a ${BATCH_RUN}${RERUN_INFO}

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
	BATCH_RUN=B
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
        CLMSGRB001=${OUTPUT_FILE}
        export CLMSGRB001
fi

echo "CLMSG00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   CLMSG00MAS=${CLMSG00MAS}"
echo "   CLMSGRB001=${CLMSGRB001}"
echo "   BATCH RANGE = ${RERUN_INFO}"
submit_clmsgrb01
date

exit 0
