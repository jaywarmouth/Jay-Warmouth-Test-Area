#!/bin/sh
# Program Name	: irever01.sh
# Description   : Initialize REVER00MAS new fields
#                
#          Command Line Arguments: 
#          -t Test Mode  
#                 
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

usage: irever01.sh -t -m -b <batchrange> -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
                -b <batchrange> - not used if PASS1=N;
                        optional if PASS1=Y (default is entire file)
		-f <file>	- assign alternate REVER00MAS

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


# Submit irever01 program
submit_irever01()
{
     runcobol ${OBJ_DIR}/irever01 -a ${LINKAGE}
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
        REVER00MASI=$FILE
	REVER00MASR=$FILE
else
        REVER00MASI=${REVER00MAS}
        REVER00MASR=${REVER00MAS}
fi
export REVER00MASI REVER00MASR  
REVERUPDTI=/tmp/REVERUPDTI; export REVERUPDTI
REVERUPDTO=/tmp/REVERUPDTO; export REVERUPDTO

echo "Initialize REVER00MAS new fields"
date
echo "REVER00MASI=${REVER00MASI}"
echo "REVER00MASR=${REVER00MASR}"
echo "REVERUPDTI=${REVERUPDTI}"
echo "REVERUPDTO=${REVERUPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_irever01 
date

exit $RETVAL
