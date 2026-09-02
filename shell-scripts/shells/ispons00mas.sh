#!/bin/sh
# Program Name	: ispons00mas.sh
# Description   : Initialize SPONS00MAS new fields
#                
# Modifications	: 2/11/2019 - TT19448-2; change obj name to ISPONS00MAS                 

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

usage: ispons00mas.sh -t -m -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
		-f <file>	- assign alternate SPONS00MAS

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


# Submit ispons00mas program
submit_ispons00mas()
{
     runcobol ${OBJ_DIR}/ISPONS00MAS -a ${LINKAGE}
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
        SPONS00MASI=$FILE
	SPONS00MASR=$FILE
else
        SPONS00MASI=${SPONS00MAS}
        SPONS00MASR=${SPONS00MAS}
fi
export SPONS00MASI SPONS00MASR  
SPONSUPDTI=/tmp/SPONSUPDTI; export SPONSUPDTI
SPONSUPDTO=/tmp/SPONSUPDTO; export SPONSUPDTO

echo "Initialize SPONS00MAS new fields"
date
echo "SPONS00MASI=${SPONS00MASI}"
echo "SPONS00MASR=${SPONS00MASR}"
echo "SPONSUPDTI=${SPONSUPDTI}"
echo "SPONSUPDTO=${SPONSUPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_ispons00mas 
date

exit $RETVAL
