#!/bin/sh
# Program Name	: iconfig0mas.sh
# Description   : Initialize CONFIG0MAS new fields
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

usage: iconfig0mas.sh -t -m -f <file>
        all input parameters are optional:
                -t - test mode = Y      (default is TEST_MODE=N)
                -m - 1stpass mode = N  (default is PASS1=Y)
		-f <file>	- assign alternate CONFIG0MAS

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


# Submit iconfig0mas program
submit_iconfig0mas()
{
     runcobol ${OBJ_DIR}/ICONFIG0MAS -a ${LINKAGE}
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
        CONFIG0MASI=$FILE
	CONFIG0MASR=$FILE
else
        CONFIG0MASI=${CONFIG0MAS}
        CONFIG0MASR=${CONFIG0MAS}
fi
export CONFIG0MASI CONFIG0MASR  
CONFIG0UPDTI=/tmp/CONFIG0UPDTI; export CONFIG0UPDTI
CONFIG0UPDTO=/tmp/CONFIG0UPDTO; export CONFIG0UPDTO

echo "Initialize CONFIG0MAS new fields"
date
echo "CONFIG0MASI=${CONFIG0MASI}"
echo "CONFIG0MASR=${CONFIG0MASR}"
echo "CONFIG0UPDTI=${CONFIG0UPDTI}"
echo "CONFIG0UPDTO=${CONFIG0UPDTO}"
echo "LINKAGE=${LINKAGE}"
submit_iconfig0mas 
date

exit $RETVAL
