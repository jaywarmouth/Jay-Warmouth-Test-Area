#!/bin/sh
#
# Program Name	: ilimit02.sh
# Description   : Initializes new fields in LIMIT00MAS file 
#                 Command Line Arguments: None
#                 -t TEST MODE  
#                 
# Author	: Lucy A. Caraballo
# Date		: 7/27/2015
# Modifications : 8/17/2015 - Production version changes
#		: 7/31/2018 - TT18645-12

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
SPONS="00000000"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ilimit02.sh -t -m -f <file>
	all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
                -f <file>       - assign alternate LIMIT00MAS

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


# Submit ilimit02 program
submit_ilimit02()
{
     runcobol ${OBJ_DIR}/ilimit02 -a ${LINKAGE}         
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
    -s) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SPONS=$1
        ;;
  esac
  shift
done
 
# Parse environment variables
parse_env

# Assign alternate environment variables
LINKAGE=${TEST_MODE}${PASS1}${SPONS}

if [ ${FILE_FLAG} = 1 ]
then
	LIMIT00MASI=${FILE}
	LIMIT00MASR=${FILE}
else
	LIMIT00MASI=${LIMIT00MAS}
        LIMIT00MASR=${LIMIT00MAS}
fi
export LIMIT00MASI LIMIT00MASR
LIMITUPDTI=/tmp/LIMITUPDTI; export LIMITUPDTI
LIMITUPDTO=/tmp/LIMITUPDTO; export LIMITUPDTO
  

echo "Initialize LIMIT00MAS new fields"
date
echo "LIMIT00MASI=${LIMIT00MASI}"
echo "LIMIT00MASR=${LIMIT00MASR}"
echo "LIMITUPDTI=${LIMITUPDTI}"
echo "LIMITUPDTO=${LIMITUPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_ilimit02 
date
echo "RET_CODE=$RETVAL"

exit $RETVAL
