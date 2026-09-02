#!/bin/ksh
#
# Program Name	: claim104.sh
# Description	: Pulls claims to work by System and Batch Range
#                 Command Line Arguments:
#                   -b <16 Char.> Batch range to process
#                   -o <filename> Output filename
#                   -s System Number
# Author	: Christina Harris
# Date		: 06/03/97
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
BATCH="null"
OUTPUT_FILE="null"
SYSTEM=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim104.sh [-b <batch range>] [-s <system number>] [-o <output file>]

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        else
          BATCH=$1
        fi
        ;;
    -s) shift
        if [ $# -le 0 ]
        then
          usage
        else
          SYSTEM=$1
        fi
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        else
          OUTPUT_FILE=$1
        fi
        ;;
  esac
  shift
done
        

# Parse environment variables
parse_env

# Assign alternate environment variables
CLWRK00MAS=${OUTPUT_FILE}
export CLWRK00MAS

echo "claim104 - Pull claims to Work by System (from CLAIM00MAS to CLWRK00MAS)"
date
echo "USER=$USER"
echo "EXPORT PATHS:"
echo "   CLWRK00MAS=$CLWRK00MAS"

if [ ${BATCH} = "null" ]
then
   usage
elif [ ${OUTPUT_FILE} = "null" ]
   then
      usage
   else
      runcobol ${OBJ_DIR}/claim104 -a ${BATCH}${SYSTEM}
fi

date

exit 0
