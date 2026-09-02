#!/bin/sh
#
# Program Name  : benefconvert.sh
# Description   : BENEF00MAS Conversion
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

usage: benefconvert.sh [-t]
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


BENEF00MASO=${BENEF00MAS}; export BENEF00MASO
BENEF00MASN=${BENEF00MAS}-NEW; export BENEF00MASN

echo "BENEF00MAS Conversion"
echo "EXPORT PATHS:"
echo "  BENEF00MASO=${BENEF00MASO}"
echo "  BENEF00MASN=${BENEF00MASN}"

date
runcobol ${OBJ_DIR}/benefconvert ${DEBUG} -k -a ${TESTMODE}
RETVAL=$?
date

exit $RETVAL

