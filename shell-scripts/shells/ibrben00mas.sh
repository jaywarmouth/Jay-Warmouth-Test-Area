#!/bin/sh
# Program Name	: ibrben00mas.sh
# Description   : Initialize BRBEN00MAS new fields
#                
# Modifications	: 2/11/2019 - TT19448-2; change obj name to IBRBEN00MAS                 

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

usage: ibrben00mas.sh -t -m -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
		-f <file>	- assign alternate BRBEN00MAS

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


# Submit ibrben00mas program
submit_ibrben00mas()
{
     runcobol ${OBJ_DIR}/IBRBEN00MAS -a ${LINKAGE}
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
        BRBEN00MASI=$FILE
	BRBEN00MASR=$FILE
else
        BRBEN00MASI=${BRBEN00MAS}
        BRBEN00MASR=${BRBEN00MAS}
fi
export BRBEN00MASI BRBEN00MASR  
BRBENUPDTI=/tmp/BRBENUPDTI; export BRBENUPDTI
BRBENUPDTO=/tmp/BRBENUPDTO; export BRBENUPDTO

echo "Initialize BRBEN00MAS new fields"
date
echo "BRBEN00MASI=${BRBEN00MASI}"
echo "BRBEN00MASR=${BRBEN00MASR}"
echo "BRBENUPDTI=${BRBENUPDTI}"
echo "BRBENUPDTO=${BRBENUPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_ibrben00mas 
date

exit $RETVAL
