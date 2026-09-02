#!/bin/sh
# Program Name	: istcfg00mas.lc
# Description   : Initialize STCFG00MAS new fields
#                                 

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

usage: istcfg00mas.sh -t -m -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
		-f <file>	- assign alternate STCFG00MAS

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


# Submit istcfg00mas program
submit_istcfg00mas()
{
     runcobol ${OBJ_DIR}/ISTCFG00MAS -a ${LINKAGE}
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
        STCFG00MASI=$FILE
	STCFG00MASR=$FILE
else
        STCFG00MASI=${STCFG00MAS}
        STCFG00MASR=${STCFG00MAS}
fi

export STCFG00MASI STCFG00MASR  
STCFG00UPDI=/tmp/STCFG00UPDTI; export STCFG00UPDTI
STCFG00UPDO=/tmp/STCFG00UPDTO; export STCFG00UPDTO

echo "Initialize STCFG00MAS new fields"
date
echo "STCFG00MASI=${STCFG00MASI}"
echo "STCFG00MASR=${STCFG00MASR}"
echo "STCFG00UPDI=${STCFG00UPDI}"
echo "STCFG00UPDO=${STCFG00UPDO}"
echo "LINKAGE=${LINKAGE}"
submit_istcfg00mas 
date

exit $RETVAL
