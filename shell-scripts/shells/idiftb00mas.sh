#!/bin/sh
# Program Name	: idiftb00mas.sh
# Description   : Initialize DIFTB00MAS new fields
#                
# Modifications	: 2/11/2019 - TT19448-2; change obj name to IDIFTB00MAS                 

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

usage: idiftb00mas.sh -t -m -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
		-f <file>	- assign alternate DIFTB00MAS

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


# Submit idiftb00mas program
submit_idiftb00mas()
{
     runcobol ${OBJ_DIR}/IDIFTB00MAS -a ${LINKAGE}
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
        DIFTB00MASI=$FILE
	DIFTB00MASR=$FILE
else
        DIFTB00MASI=${DIFTB00MAS}
        DIFTB00MASR=${DIFTB00MAS}
fi
export DIFTB00MASI DIFTB00MASR  
DIFTBUPDTI=/tmp/DIFTBUPDTI; export DIFTBUPDTI
DIFTBUPDTO=/tmp/DIFTBUPDTO; export DIFTBUPDTO

echo "Initialize DIFTB00MAS new fields"
date
echo "DIFTB00MASI=${DIFTB00MASI}"
echo "DIFTB00MASR=${DIFTB00MASR}"
echo "DIFTBUPDTI=${DIFTBUPDTI}"
echo "DIFTBUPDTO=${DIFTBUPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_idiftb00mas 
date

exit $RETVAL
