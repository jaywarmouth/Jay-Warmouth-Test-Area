#!/bin/sh
# Program Name	: idrug000mas.sh
# Description   : Initialize DRUG000MAS new fields
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

usage: idrug000mas.sh -t -m -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
		-f <file>	- assign alternate DRUG000MAS

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


# Submit idrug000mas program
submit_idrug000mas()
{
     runcobol ${OBJ_DIR}/IDRUG000MAS -a ${LINKAGE}
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
        DRUG000MASI=$FILE
	DRUG000MASR=$FILE
else
        DRUG000MASI=${DRUG000MAS}
        DRUG000MASR=${DRUG000MAS}
fi
export DRUG000MASI DRUG000MASR  
DRUG0UPDTI=/tmp/DRUG0UPDTI; export DRUG0UPDTI
DRUG0UPDTO=/tmp/DRUG0UPDTO; export DRUG0UPDTO

echo "Initialize DRUG000MAS new fields"
date
echo "DRUG000MASI=${DRUG000MASI}"
echo "DRUG000MASR=${DRUG000MASR}"
echo "DRUG0UPDTI=${DRUG0UPDTI}"
echo "DRUG0UPDTO=${DRUG0UPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_idrug000mas 
date

exit $RETVAL
