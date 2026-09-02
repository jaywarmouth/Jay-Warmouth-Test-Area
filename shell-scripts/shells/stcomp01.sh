#!/bin/sh
#
# Program Name  : stcomp01.sh
# Description   : Warehouse STCOMPRB001 Extract
#		  Command Line Arguments: None
#                
#
# Variables Used:
PATH=/opt/rmcobol:$PATH
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0
DEBUG=" "
DATETM=`date +%Y%m%d-%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: stcomp01.sh [-D]

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


# Submit stcomp01 program
submit_stcomp01()
{
        runcobol ${OBJ_DIR}/stcomp01 ${DEBUG}  
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
    -D) DEBUG="D"
        ;;
  esac
  shift
done

parse_env

# Assign alternate environment variables

echo "STCOMP0MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   STCOMP0MAS=${STCOMP0MAS}"
echo "   STCOMPRB001=${STCOMPRB001}"
submit_stcomp01
date
echo "RETURN_CODE=$RETVAL"

exit $RETVAL
