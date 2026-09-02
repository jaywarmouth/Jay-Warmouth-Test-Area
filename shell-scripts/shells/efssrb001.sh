#!/bin/ksh
#
# Program Name	: efssrb01.sh
# Description   : EFSS000MAS extract to warehouse.
#                 Command line arguments:
#		  -o <filename> Assign alternate output EFSSRB001 file name
#		  -b <Date Range Type> - Must match an item in the DATECARD file
#			
# Author	: Linda Jefferis
# Date		: 09/06/2016
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE_FLAG=0
OUTPUT_FILE="null"
RUNTYPE=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: efssrb01.sh [-o <filename>] [-b <datetype>]

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

# Submit efssrb01 program
submit_efssrb01()
{
     runcobol ${OBJ_DIR}/efssrb001 -a ${RUNTYPE}
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
	RUNTYPE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

if [ $RUNTYPE = 0 ]
then
        usage
        exit 1
fi

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
   	EFSSRB001=${OUTPUT_FILE}
   	export EFSSRB001
fi

DATECARD=/usr/lnk/log/DATECARD.txt
  export DATECARD

echo "Extract of EFSS000MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   EFSS000MAS=${EFSS000MAS}"
echo "   EFSSRB001=${EFSSRB001}"
echo "   DATECARD=${DATECARD}"
submit_efssrb01
date

exit $RETVAL
