#!/bin/ksh
#
# Program Name	: check04.sh
# Description   : CHECK00MAS extract to warehouse.
#                 Command line arguments:
#                 -f Complete update(Full-Run)
#		  -o <filename> Assign alternate output CHECKRB01 file name
# Author	: John Kutchenriter
# Date		: 11/02/2009
# Modifications : 12/04/2009 - fixed runcobol command (-f to -s) 
#		: 02/22/2019 - Fix FULL_RUN logic
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

usage: check04.sh [-f] [-o <filename>]

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

# Submit check04 program
submit_check04()
{
     runcobol ${OBJ_DIR}/check04 -a ${FULL_RUN}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) FULL_RUN=F
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
   	CHECKRB001=${OUTPUT_FILE}
   	export CHECKRB001
fi



echo "Extract of CHECK00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   CHECKRB001=${CHECKRB001}"
submit_check04
date

exit 0

