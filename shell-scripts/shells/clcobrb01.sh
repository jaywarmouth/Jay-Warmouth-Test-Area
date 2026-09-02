#!/bin/ksh
#
# Program Name  : clcobrb01.sh
# Description   : Warehouse Clcob00Mas File Extract
#		  Command Line Arguments:
#                 -f Complete update(Full-Run)
#                 -b Batch Range 
#		  -o <alternate output file name>
# Author        : Mike Paulus
# Date          : 10/06/11
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FULL_RUN=0
OUTPUT_FILE="null"
RERUN_INFO="null"
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clcobrb01.sh [-f] [-b <batch-range>] [-o <output filename>]

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


# Submit clcobrb01 program
submit_clcobrb01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/clcobrb01 -s ${FULL_RUN} -a ${RERUN_INFO}  

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) FULL_RUN=1
        ;;
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
        CLCOBRB001=${OUTPUT_FILE}
        export CLCOBRB001
fi

echo "CLCOB00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   CLCOB00MAS=${CLCOB00MAS}"
echo "   CLCOBRB001=${CLCOBRB001}"
echo "   BATCH RANGE = ${RERUN_INFO}"
submit_clcobrb01
date

exit 0
