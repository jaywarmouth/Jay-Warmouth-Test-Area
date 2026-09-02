#!/bin/sh
#
# Program Name	: numotrb01.sh
# Description   : Export NUMOT00MAS file to Warehouse
#          Command Line Arguments:  
#                 -o <filename> Assign alternate output NUMOTRB001 file name
#                 -b <Date Range Type> - Must match an item in the DATECARD file
#                       

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0
OUTPUT_FILE="null"
RUNTYPE=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: numotrb01.sh [-b <runtype>] 

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


# Submit numotrb01 program
submit_numotrb01()
{
     runcobol ${OBJ_DIR}/numotrb01 -a ${RUNTYPE}  
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
        NUMOTRB001=${OUTPUT_FILE}
        export NUMOTRB001
fi

DATECARD=/usr/lnk/log/DATECARD.txt
  export DATECARD
  

echo "NUMOT00MAS extract for Warehouse"
date
echo "NUMOT00MAS=${NUMOT00MAS}"
echo "NUMOTRB001=${NUMOTRB001}"
echo "DATECARD=${DATECARD}"
submit_numotrb01 
echo  "   RETVAL=$? "

date

exit $RETVAL
