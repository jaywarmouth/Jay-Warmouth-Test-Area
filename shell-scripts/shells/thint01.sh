#!/bin/sh
#
# Program Name  : thint01.sh
# Description   : Warehouse THINT00MAS File Extract
#                 Command Line Arguments:
#                 -f Complete update(Full-Run)
#                 -o <alt. output file name>
# Author        : Linda Jefferis
# Date          : 04/13/2010
# Modifications : 10/05/2017 - add command line logic
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FULL_RUN=0
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: thint01.sh [-f] [-o <filename>]

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


# Submit thint01 program
submit_thint01()
{
        runcobol ${OBJ_DIR}/thint01 -s ${FULL_RUN}
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
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
        THINTRB001=${OUTPUT_FILE}
        export THINTRB001
fi

echo "THINT00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   THINT00MAS=${THINT00MAS}"
echo "   THINTRB001=${THINTRB001}"
submit_thint01
date

echo "RETVAL=$RETVAL"

exit $RETVAL
