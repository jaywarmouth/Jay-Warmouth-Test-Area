#!/bin/sh
#
# Program Name  : fvssconvert.sh
# Description   : FVSS0M00MAS Conversion
# Author        : 
# Date          : 
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
   -t = test mode, data written to FVSSOINFOT.csv instead of FVSS000MAS

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


FVSS000MASO=${FVSS000MAS}; export FVSS000MASO
FVSS000MASN=${FVSS000MAS}-NEW; export FVSS000MASN

FVSSOINFOT=/tmp/FVSSOINFOT.csv-${VERS}; export FVSSOINFOT
FVSSOERROR=/tmp/FVSSOERROR.csv-${VERS}; export FVSSOERROR

echo "FVSS000MAS Conversion"
echo "EXPORT PATHS:"
echo "   FVSS000MASO=${FVSS000MASO}"
echo "   FVSS000MASN=${FVSS000MASN}"
echo "   FVSSOINFOT=${FVSSOINFOT}  (only filled in test mode)"
echo "   FVSSOERROR=${FVSSOERROR}"

date
runcobol ${OBJ_DIR}/fvssconvert -C /usr/rmcobol/terminfo-d0.cfg -a ${TESTMODE}
RETVAL=$?
date

