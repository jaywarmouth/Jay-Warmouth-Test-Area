#!/bin/ksh
#
# Program Name  : excep01.sh
# Description   : Warehouse EXCEP00MAS File Extract
#		  Command Line Arguments:
#                 -f Complete update(Full-Run)
#                 -o <filename> Assign alternate output EXCEPRB001 file name
# Author        : Kathy Ritzler
# Date          : 01/26/04
# Modifications : 05/05/08  Add full run option
#		: 10/19/2012 - Removed logic for special FULL file name
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
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: excep01.sh [-f] [-o <filename>]

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


# Submit excep01 program
submit_excep01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/excep01 -s ${FULL_RUN}  

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
        EXCEPRB001=${OUTPUT_FILE}
        export EXCEPRB001
fi

echo "EXCEP00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   EXCEPRB001=${EXCEPRB001}"
submit_excep01
date

exit 0
