#!/bin/sh
#
# Program Name	: nsderb01.sh
# Description   : NSDE000MAS extract to warehouse.
#		: Command line arguments:
#                 -o <filename> Assign alternate output NSDERB001 file name
#                 -b <Date Range Type> - Must match an item in the DATECARD file
#           
# Author	: Linda Jefferis
# Date		: 11/13/2014
# Modifications	: 03/31/2015 - Updates for RUNTYPE and DATECARD logic (TT #12829-43)
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

usage: nsderb01.sh -b RUNTYPE -o <alt NSDERB001 filename>

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

# Submit 01 program
submit_nsderb01()
{
     runcobol ${OBJ_DIR}/nsderb01 -a ${RUNTYPE}
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
        NSDERB001=${OUTPUT_FILE}
        export NSDERB001
fi

DATECARD=/usr/lnk/log/DATECARD.txt
export DATECARD

echo "Extract of NSDE000MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   NSDE000MAS=$NSDE000MAS"
echo "   NSDERB001=$NSDERB001"
echo "   DATECARD=${DATECARD}"
submit_nsderb01
date

exit 0
