#!/bin/ksh
#
# Program Name	: diftb01.sh
# Description   : DIFTB00MAS extract to warehouse.
#                 Command line arguments:
#		  -o <filename> Assign alternate output DIFTBRB001 file name
# Author	: Mike Paulus
# Date		: 08/05/2008
# Modifications :                                                            
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE_FLAG=0
OUTPUT_FILE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: diftb01.sh [-o <filename>]

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

# Submit diftb01 program
submit_diftb01()
{
     runcobol ${OBJ_DIR}/diftb01  
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
   	DIFTBRB001=${OUTPUT_FILE}
   	export DIFTBRB001
fi

echo "Extract of DIFTB00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   DIFTBRB001=${DIFTBRB001}"
submit_diftb01
date

exit 0
