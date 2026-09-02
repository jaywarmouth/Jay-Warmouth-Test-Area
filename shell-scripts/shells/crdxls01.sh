#!/bin/sh
#
# Program Name  : crdxls01.sh
# Description   : EXCEL FILE CONVERSION
#		  Command Line Arguments:
#                 -f <File Name>
#		  -p - pipe delimiter flag
# Author        : Jim Masluk
# Date          : 10/26/06
# Modifications :
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE_NAME="null"
TEST_MODE=0
DELIMITER=","
FOLDER=null
length=15
RETVAL=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: crdxls01.sh  [-t] -f [file name] 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file...                                                 "

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


# Submit crdxls01 program
submit_crdxls01()
{
    runcobol ${OBJ_DIR}/crdxls01 -s ${TEST_MODE} -a "${DELIMITER}${FILE_NAME}${FOLDER}"
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
    -t) TEST_MODE=1
        ;;
    -f) shift
        FILE_NAME=$1
       ;;
    -p) DELIMITER="|"
        ;;
  esac
  shift
done


FILE_NAME=`printf "%-15s" "$FILE_NAME"`

# Parse environment variables
parse_env

# Assign alternate environment variables

FOLDER="/usr/lnk/elig_in/"

echo "EXCEL File Conversion"
date
submit_crdxls01
date

exit ${RETVAL}
