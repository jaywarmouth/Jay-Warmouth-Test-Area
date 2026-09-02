#!/bin/sh
#
# Program Name  : tittracrb01.sh
# Description   : Warehouse TITTRACMAS Extract - Full file extract
#                 -o <filename> Assign alternate output CLMSSRB001 file name
#                 -b <Date Range Type> - Must match an item in the DATECARD file
# Modifications :
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0
FILE_FLAG=0
OUTPUT_FILE="null"
RUNTYPE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tittracrb01.sh [-o <filename>] [-b <datetype>]

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


# Submit tittracrb01 program
submit_tittracrb01()
{
        runcobol ${OBJ_DIR}/tittracrb01 -a ${RUNTYPE}
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
        TITTRACRB01=${OUTPUT_FILE}
        export TITTRACRB01
fi

DATECARD=/usr/lnk/log/DATECARD.txt
  export DATECARD


echo "TITTRACMAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   TITTRACMAS=${TITTRACMAS}"
echo "   TITTRACRB01=${TITTRACRB01}"
echo "   DATECARD=${DATECARD}"
submit_tittracrb01
date

exit $RETVAL
