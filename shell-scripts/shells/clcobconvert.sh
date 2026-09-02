#!/bin/sh
#
# Program Name  : clcobconvert.sh
# Description   : CLCOB00MAS Conversion
# Author        : Bill Swidal 
# Date          : 3/30/2020
# Modifications :
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clcobconvert.sh [-t]
    (-t is test mode, bypasses new version creation)

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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


#
# Main routine
#

# Parse environment variables
parse_env

# Assign alternate environment variables

DEBUG=""
TESTMODE=0

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -D) DEBUG="D"
        ;;
    -t) TESTMODE=1
        ;;
     *) usage
        ;;
  esac
  shift
done

CLCOB00MASN=${CLCOB00MAS}-NEW
export CLCOB00MASN

CLCOB00MASO=${CLCOB00MAS}
export CLCOB00MASO



echo "CLCOB00MAS Conversion"
echo "EXPORT PATHS:"
echo "  CLCOB00MASO=${CLCOB00MASO}"
echo "  CLCOB00MASN=${CLCOB00MASN}"

date
runcobol ${OBJ_DIR}/clcobconvert
RETVAL=$?
date

exit $RETVAL

