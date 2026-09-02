#!/bin/ksh
#
# Program Name	: susp004.sh
# Description   : SUSP000MAS extract to warehouse.
#                 Command line arguments:
#                 -f Complete update(Full-Run)
#		  -o <filename> Assign alternate output SUSPRB001 file name
# Author	: John Kutchenriter
# Date		: 10/01/2009
# Modifications :                                                            
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FULL_RUN=0
FILE_FLAG=0
OUTPUT_FILE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: susp004.sh [-f] [-o <filename>]

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

# Submit susp004 program
submit_susp004()
{
     runcobol ${OBJ_DIR}/susp004 -s ${FULL_RUN} 
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
   	SUSPRB001=${OUTPUT_FILE}
   	export SUSPRB001
fi

echo "Extract of SUSP000MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   SUSPRB001=${SUSPRB001}"
submit_susp004
date

exit 0
