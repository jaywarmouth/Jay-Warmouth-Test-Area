#!/bin/sh
#
# Program Name  : gdescconvert.sh
# Description   : GDESCM00MAS Conversion
# Author        : Bill Swidal 
# Date          : 1/25/2021
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

usage: gdescconvert.sh [-t]
   -t = test mode, data written to GDESCOINFOT.csv instead of GDESC00MAS 

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
VERS="curr"
TESTMODE=0

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TESTMODE=1
        ;;
     *) usage
        ;;
  esac
  shift
done


GDESC00MASO=${GDESC00MAS}; export GDESC00MASO
GDESC00MASN=${GDESC00MAS}-NEW; export GDESC00MASN

GDESCOINFOT=/tmp/GDESCOINFOT.csv; export GDESCOINFOT
GDESCOERROR=/tmp/GDESCOERROR.csv; export GDESCOERROR

echo "GDESC00MAS Conversion"
echo "EXPORT PATHS:"
echo "   GDESC00MASO=${GDESC00MASO}"
echo "   GDESC00MASN=${GDESC00MASN}"
echo "   GDESCOINFOT=${GDESCOINFOT}  (only filled in test mode)"
echo "   GDESCOERROR=${GDESCOERROR}"

date
runcobol ${OBJ_DIR}/gdescconvert -a ${TESTMODE}
RETVAL=$?
date

