#!/bin/ksh
#
# Program Name  : npixls01.sh
# Description   : EXCEL FILE NPI LOAD
#		  Command Line Arguments:
#                 -f File Name - Assign alternate input filename
# Author        : Jim Masluk
# Date          : 03/14/08
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
FILE_FLAG=0
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: npixls01.sh  [-t] -f [file name] 

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


# Submit npixls01 program
submit_npixls01()
{
    echo ${DATE}
    runcobol ${OBJ_DIR}/npixls01 -s ${TEST_MODE}

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
	FILE_FLAG=1
        FILE_NAME=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
	NPIXLS01TAP=$FILE_NAME
	export NPIXLS01TAP
fi


echo "EXCEL File NPI Load"
echo ""
echo "FILE PATHS:"
echo "     NPICMS0MAS=$NPICMS0MAS"
echo "     NPIXLS01TAP=$NPIXLS01TAP"
echo ""
date
submit_npixls01
date

exit 0
