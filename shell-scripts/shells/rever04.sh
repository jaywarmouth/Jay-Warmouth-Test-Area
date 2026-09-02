#!/bin/ksh
#
# Program Name  : rever04.sh
# Description   : Warehouse Rever00Mas File Extract
#		  Command Line Arguments:
#                 -f Complete update(Full-Run)
#                 -o <filename> Assign alternate output REVERRB001 file name
#                 -b Batch Range 
# Author        : Mike Paulus
# Date          : 09/01/11
# Modifications : 03/27/2015 - RETVAL and exit code 99 logic (TT #8641-9)
#		: 07/17/2017 - TT17453-1; fix/enhance RETVAL logic.
#		: 08/31/2017 - TT13915-54; change rucobol command
#		: 11/03/2017 - Remove coding for Full file. Cobol no longer uses these flags. (DME)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
OUTPUT_FILE="null"
RERUN_INFO="null"
FILE_FLAG=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rever04.sh [-o <filename>] [-b <batch-range>]

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


# Submit rever04 program
submit_rever04()
{
        runcobol ${OBJ_DIR}/rever04 -a ${RERUN_INFO}  
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
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	RERUN_INFO=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
        REVERRB001=${OUTPUT_FILE}
        export REVERRB001
fi

echo "REVER00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   REVER00MAS=${REVER00MAS}"
echo "   REVERRB001=${REVERRB001}"
echo "   BATCH RANGE = ${RERUN_INFO}"
submit_rever04
echo ""
echo "RETVAL=$RETVAL"
date

exit ${RETVAL}
