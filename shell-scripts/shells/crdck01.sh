#!/bin/ksh
#
# Program Name  : crdck01.sh
# Description   : CARDH29MAS FILE CHECK
#		  Command Line Arguments:
#                 -f File Name
# Author        : Jim Masluk
# Date          : 05/16/08
# Modifications :
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
#OBJ_DIR=/data/phase1fil/OBJ
FILE_NAME="null"
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: crdck01.sh  [-t] -f [file name] 

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


# Submit crdck01 program
submit_crdck01()
{
    echo ${DATE}
    FOLDER="/usr/lnk/elig_in/"
    #FOLDER="/media/test/TC05/change_output/"

    runcobol ${OBJ_DIR}/crdck01 -s ${TEST_MODE}  -a ${FILE_NAME}${FOLDER}

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

FILE_NAME=`printf "%-20s" "$FILE_NAME"`

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "CARDH29MAS FILE CHECK"
date
submit_crdck01
date

exit 0
