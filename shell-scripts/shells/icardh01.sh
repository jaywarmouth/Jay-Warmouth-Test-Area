#!/bin/sh
#
# Program Name	: icardh01.sh
# Description   : Initializes new fields in CARDH00MAS file 
#                 Command Line Arguments: None
#                 -t TEST MODE  
#                 
# Date		: 09/06/2018

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
LINKAGE=""
TEST_MODE="N"
PASS1="Y"
FILE_FLAG=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: icardh01.sh -t -m -f <file>
	all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
                -f <file>       - assign alternate CARDH00MAS

ENDOFUSAGE
  exit 99
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


# Submit icardh01 program
submit_icardh01()
{
     runcobol ${OBJ_DIR}/icardh01 -a ${LINKAGE}         
	RETVAL=$?
}


# Main routine#
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE="Y"
        ;;
    -m) PASS1="N"
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;
  esac
  shift
done
 
# Parse environment variables
parse_env

# Assign alternate environment variables
LINKAGE=${TEST_MODE}${PASS1}

if [ ${FILE_FLAG} = 1 ]
then
	CARDH00MASI=${FILE}
	CARDH00MASR=${FILE}
else
	CARDH00MASI=${CARDH00MAS}
        CARDH00MASR=${CARDH00MAS}
fi
export CARDH00MASI CARDH00MASR
CARDHUPDTI=/tmp/CARDHUPDTI; export CARDHUPDTI
CARDHUPDTO=/tmp/CARDHUPDTO; export CARDHUPDTO
  

echo "Initialize CARDH00MAS new fields"
date
echo "CARDH00MASI=${CARDH00MASI}"
echo "CARDH00MASR=${CARDH00MASR}"
echo "CARDHUPDTI=${CARDHUPDTI}"
echo "CARDHUPDTO=${CARDHUPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_icardh01 
date
echo "RET_CODE=$RETVAL"

exit $RETVAL
