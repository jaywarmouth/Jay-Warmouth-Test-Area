#!/bin/sh
# Program Name	: iclmss01.sh
# Description   : Initializes new fields in CLMSS00MAS SNAP SHOT file 
#                 Command Line Arguments: 
#		all input parameters are optional:
#                -t - test mode = Y      (default is TEST_MODE=N)
#                -m - 1stpass mode = N  (default is PASS1=Y)
#                -b <batchrange> - not used if PASS1=N;
#                        optional if PASS1=Y (default is entire file)
#			<batchrange> can also be just a begin batch
#                 
# Author	: Lucy A. Caraballo
# Date		: 2/04/2015
# Modifications : 03/09/2015 - Modifications for production version (LSJ)
#		: 12/15/2017 - TT:17552-55; Program logic totally redone.

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

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: iclmss01.sh -t -m -b <batchrange>
	all input parameters are optional:
		-t - test mode = Y	(default is TEST_MODE=N)
		-m - 1stpass mode = N  (default is PASS1=Y)
		-b <batchrange> - not used if PASS1=N;
			optional if PASS1=Y (default is entire file)

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


# Submit iclmss01 program
submit_iclmss01()
{
     runcobol ${OBJ_DIR}/iclmss01 -a ${LINKAGE}         
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
    -b) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	BATCHRGE_FLG=1
	BATCHRGE=$1
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
CLMSS00MASR=${CLMSS00MAS}; export CLMSS00MASR
CLMSS00MASI=${CLMSS00MAS}; export CLMSS00MASI
CLMSSUPDTI=/tmp/CLMSSUPDTI; export CLMSSUPDTI
CLMSSUPDTO=/tmp/CLMSSUPDTO; export CLMSSUPDTO
  

echo "Initialize CLMSS00MAS new fields"
date
echo "CLMSS00MASR=${CLMSS00MASR}"
echo "CLMSS00MASI=${CLMSS00MASI}"
echo "CLMSSUPDTI=${CLMSSUPDTI}"
echo "CLMSSUPDTO=${CLMSSUPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_iclmss01 
date
echo  "   RET_CODE=$RETVAL"

exit $RETVAL
