#!/bin/ksh
#
# Program Name	: clmssrb01.sh
# Description   : CLMSS00MAS extract to warehouse.
#                 Command line arguments:
#		  -o <filename> Assign alternate output CLMSSRB001 file name
#		  -b <Date Range Type> - Must match an item in the DATECARD file
#			
# Author	: Linda Jefferis
# Date		: 12/15/2014
# Modifications : 03/31/2015 - Add "RUNTYPE" and DATECARD logic (TT #12829-45)
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

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: clmssrb01.sh [-f] [-o <filename>] [-b <datetype>]

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

# Submit clmssrb01 program
submit_clmssrb01()
{
     runcobol ${OBJ_DIR}/clmssrb01 -a ${RUNTYPE}
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
   	CLMSSRB001=${OUTPUT_FILE}
   	export CLMSSRB001
fi

DATECARD=/usr/lnk/log/DATECARD.txt
  export DATECARD

echo "Extract of CLMSS00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   CLMSS00MAS=${CLMSS00MAS}"
echo "   CLMSSRB001=${CLMSSRB001}"
echo "   DATECARD=${DATECARD}"
submit_clmssrb01
date

exit 0
