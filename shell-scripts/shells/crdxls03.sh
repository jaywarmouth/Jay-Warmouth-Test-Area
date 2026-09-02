#!/bin/ksh
#
# Program Name  : crdxls03.sh
# Description   : EXCEL FILE CONVERSION
#		  Command Line Arguments:
#                 -f File Name
# Author        : Jim Masluk
# Date          : 09/09/09
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

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: crdxls03.sh  [-t] -f [file name] 

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


# Submit crdxls03 program
submit_crdxls03()
{
    echo ${DATE}
    runcobol ${OBJ_DIR}/crdxls03 -s ${TEST_MODE} -a ${FILE_NAME}

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
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "EXCEL File Conversion"
date
submit_crdxls03
date

exit 0
