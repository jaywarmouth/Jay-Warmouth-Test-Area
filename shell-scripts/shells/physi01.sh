#!/bin/ksh
#
# Program Name	: physi01.sh
# Description   : PHYSI00MAS extract to warehouse.
#                 Command line arguments:
#                 -f Complete update(Full-Run)
#		  -o <filename> Assign alternate output PHYSIRB001 file name
# Author	: Mike Paulus
# Date		: 01/30/2008
# Modifications : 10/19/2012 - Removed logic for special FULL file name
#		: 7/5/2016 - TT15133-16 (exit coding change)
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
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: physi01.sh [-f] [-o <filename>]

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

# Submit physi01 program
submit_physi01()
{
     runcobol ${OBJ_DIR}/physi01 -s ${FULL_RUN}  
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
   	PHYSIRB001=${OUTPUT_FILE}
   	export PHYSIRB001
fi


echo "Extract of PHYSI00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   PHYSIRB001=${PHYSIRB001}"
submit_physi01
date

exit $RETVAL
