#!/bin/sh
#
#
# Program Name	: REIMBCONVERT.CBL
# Description   : Converts fields in REIMB00MAS file 
#                 Command Line Arguments: None
#                 -t TEST MODE  
#                 
# Author	: Greg Vernon  

 
# Date		: 9/07/2018
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
DATETM=`date +%Y%m%d-%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: reimbconvert.sh [-t]

ENDOFUSAGE
  exit 1
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


# Submit REIMBCONVERT program
submit_reimbconvert()
{
     runcobol ${OBJ_DIR}/REIMBCONVERT -a ${TEST_MODE}
	RETVAL=$?
}



# Main routine#
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1
        ;;
  esac
  shift
done
 
# Parse environment variables
parse_env

# Assign alternate environment variables
  
REIMB00MASN=${REIMB00MAS}-NEW
export REIMB00MASN

REIMB00MASO=${REIMB00MAS}
export REIMB00MASO


echo "CONVERT REIMB00MAS NEW FILE"

date

echo "REIMB00MASN=${REIMB00MASN}"
echo "REIMB00MASO=${REIMB00MASO}"

submit_reimbconvert

date

exit ${RETVAL}
