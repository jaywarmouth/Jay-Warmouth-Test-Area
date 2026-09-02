#!/bin/ksh
#
# Program Name  : rebadrb01.sh
# Description   : Warehouse REBAD00MAS File Extract
#		  Command Line Arguments:
#		  -o <alt. output file name>
# Author        : Debbe Adgate
# Date          : 06/23/16
# Modifications : 07/07/2016 - TT15027-8 Changes for production version of script.
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rebadrb01.sh [-o <filename>]

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


# Submit rebadrb01 program
submit_rebadrb01()
{
        runcobol ${OBJ_DIR}/rebadrb01  
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
        REBADRB001=${OUTPUT_FILE}
        export REBADRB001
fi

echo "REBAD00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   REBAD00MAS=${REBAD00MAS}"
echo "   REBADRB001=${REBADRB001}"
submit_rebadrb01
date

echo "RETVAL=$RETVAL"

exit $RETVAL

