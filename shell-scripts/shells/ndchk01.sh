#!/bin/sh
#
# Program Name  : ndchk01.sh
# Description   : Warehouse NDCHK00MAS File Extract
#		  Command Line Arguments:
#		  -o <alt. output file name>
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ndchk01.sh [-o <filename>]

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


# Submit ndchk01 program
submit_ndchk01()
{
        runcobol ${OBJ_DIR}/ndchk01 
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
        NDCHKRB001=${OUTPUT_FILE}
        export NDCHKRB001
fi

echo "NDCHK00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   NDCHK00MAS=${NDCHK00MAS}"
echo "   NDCHKRB001=${NDCHKRB001}"
submit_ndchk01
date
echo "RETURN_CODE=$RETVAL"

exit $RETVAL
