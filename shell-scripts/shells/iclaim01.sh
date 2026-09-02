#!/bin/sh
# Program Name	: iclaim01.sh
# Description   : Initialize CLAIM00MAS new fields
#                
#          Command Line Arguments: 
#          -t Test Mode  
#                 
# Author	: Janice L. Lanzo
# Date		: 12/02/2014
# Modifications : 12/10/2014
#		: 07/27/2017 - TT17462-1
#		: 1/4/2018 - TT17884-1; program logic reworked.

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
LINKAGE=""
TEST_MODE="N"
BATCHRGE=""
BATCHRGE_FLG=0
PASS1="Y"
FILE_FLAG=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: iclaim01.sh -t -m -b <batchrange> -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
                -b <batchrange> - not used if PASS1=N;
                        optional if PASS1=Y (default is entire file)
		-f <file>	- assign alternate CLAIM00MAS

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


# Submit iclaim01 program
submit_iclaim01()
{
     runcobol ${OBJ_DIR}/iclaim01 -a ${LINKAGE}
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
    -t) TEST_MODE="Y"
        ;;
    -m) PASS1="N"
        ;;
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        BATCHRGE_FLG=1
        BATCHRGE=$1
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
if [ ${BATCHRGE_FLG} = 1 ]
then
        LINKAGE=${TEST_MODE}${PASS1}${BATCHRGE}
else
        LINKAGE=${TEST_MODE}${PASS1}
fi
if [ ${FILE_FLAG} = 1 ]
then
        CLAIM00MASI=$FILE
	CLAIM00MASR=$FILE
else
        CLAIM00MASI=${CLAIM00MAS}
        CLAIM00MASR=${CLAIM00MAS}
fi
export CLAIM00MASI CLAIM00MASR  
CLAIMUPDTI=/tmp/CLAIMUPDTI; export CLAIMUPDTI
CLAIMUPDTO=/tmp/CLAIMUPDTO; export CLAIMUPDTO

echo "Initialize CLAIM00MAS new fields"
date
echo "CLAIM00MASI=${CLAIM00MASI}"
echo "CLAIM00MASR=${CLAIM00MASR}"
echo "CLAIMUPDTI=${CLAIMUPDTI}"
echo "CLAIMUPDTO=${CLAIMUPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_iclaim01 
date

exit $RETVAL
