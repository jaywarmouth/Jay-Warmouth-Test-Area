#!/bin/sh
# Program Name	: iplan000mas.sh
# Description   : Initialize PLAN000MAS new fields
#                
#          Command Line Arguments: 
#          -t Test Mode  
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

usage: iplan000mas.sh -t -m -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
		-f <file>	- assign alternate PLAN000MAS

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


# Submit iplan000mas program
submit_iplan000mas()
{
     runcobol ${OBJ_DIR}/IPLAN000MAS -a ${LINKAGE}
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
        PLAN000MASI=$FILE
	PLAN000MASR=$FILE
else
        PLAN000MASI=${PLAN000MAS}
        PLAN000MASR=${PLAN000MAS}
fi
export PLAN000MASI PLAN000MASR  
PLAN0UPDTI=/tmp/PLAN0UPDTI; export PLAN0UPDTI
PLAN0UPDTO=/tmp/PLAN0UPDTO; export PLAN0UPDTO

echo "Initialize PLAN000MAS new fields"
date
echo "PLAN000MASI=${PLAN000MASI}"
echo "PLAN000MASR=${PLAN000MASR}"
echo "PLAN0UPDTI=${PLAN0UPDTI}"
echo "PLAN0UPDTO=${PLAN0UPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_iplan000mas 
date

exit $RETVAL
