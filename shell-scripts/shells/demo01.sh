#!/bin/ksh
#
# Program Name	: demo01.sh
# Description   : Run Demo report set 
# Author	: Linda S. Jefferis
# Date		: 11/15/1999
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: demo01.sh

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

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign Alternate variables
ENV_FILE=/usr/lnk/demo/env_var.demo
parse_env
RPTAB00MAS=/usr/lnk/demo/RPTAB00MAS
export RPTAB00MAS

runcobol ${OBJ_DIR}/claim09 -s 000
runcobol ${OBJ_DIR}/claim12 -s 00
#runcobol ${OBJ_DIR}/claim11 -s 0
#runcobol ${OBJ_DIR}/claim13 -s 100000
#runcobol ${OBJ_DIR}/claim13 -s 010000
#runcobol ${OBJ_DIR}/claim13 -s 001000
#runcobol ${OBJ_DIR}/claim13 -s 000100
#runcobol ${OBJ_DIR}/claim31 -s 00
#runcobol ${OBJ_DIR}/claim32 -s 0
#runcobol ${OBJ_DIR}/claim36
#runcobol ${OBJ_DIR}/claim38 -s 10000
#runcobol ${OBJ_DIR}/claim38 -s 01000
#runcobol ${OBJ_DIR}/claim38 -s 00100
#runcobol ${OBJ_DIR}/claim38 -s 00110
#runcobol ${OBJ_DIR}/claim56 -s 111
#runcobol ${OBJ_DIR}/claim57 
#runcobol ${OBJ_DIR}/claim39
#runcobol ${OBJ_DIR}/claim34 -s 00
#runcobol ${OBJ_DIR}/claim07 -s 0100
#runcobol ${OBJ_DIR}/claim06 -s 01
#runcobol ${OBJ_DIR}/claim28 -s 010
#runcobol ${OBJ_DIR}/claim20 -s 0010
#runcobol ${OBJ_DIR}/claim37 -s 01
#runcobol ${OBJ_DIR}/claim16 -s 0100
#runcobol ${OBJ_DIR}/claim16 -s 1010
#runcobol ${OBJ_DIR}/claim16 -s 1001
#runcobol ${OBJ_DIR}/claim29 -a AE01A000AH00A000
#runcobol ${OBJ_DIR}/claim33
#runcobol ${OBJ_DIR}/claim19 -s 00000010 -a Dljefferi


date

exit 0
