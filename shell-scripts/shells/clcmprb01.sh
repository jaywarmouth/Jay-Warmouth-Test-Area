#!/bin/ksh
#
# Program Name  : clcmprb01.sh
# Description   : Warehouse Clcmp00Mas File Extract
#		  Command Line Arguments:
#                 -f Complete update(Full-Run)
#		  -o <alt. output file name>
# Author        : Mike Paulus
# Date          : 10/05/11
# Modifications : 05/17/2016 - TT15133-11
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FULL_RUN=0
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clcmprb01.sh [-f] [-o <filename>]

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


# Submit clcmprb01 program
submit_clcmprb01()
{
        runcobol ${OBJ_DIR}/clcmprb01 -a ${RUN_TYPE}  
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
        CLCMPRB001=${OUTPUT_FILE}
        export CLCMPRB001
fi
if [ ${FULL_RUN} = 1 ]
then
	RUN_TYPE=F
else
	RUN_TYPE=P
fi

echo "CLCMP00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   CLCMP00MAS=${CLCMP00MAS}"
echo "   CLCMPRB001=${CLCMPRB001}"
echo "   Type of Run = ${RUN_TYPE}"
submit_clcmprb01
date

exit ${RETVAL}
