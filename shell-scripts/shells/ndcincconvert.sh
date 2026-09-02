#!/bin/sh
#
# Program Name	: ndcincconvert.sh
# Description   : create new file with correct GROUP format
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Greg Vernon 
# Date		: 07/11/2022
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ndcincconvert.sh [-t]

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


# Submit ndcincconvert program
submit_ndcincconvert()
{
      runcobol ${OBJ_DIR}/NDCINCCONVERT -s ${TEST_MODE}  
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
    -t) TEST_MODE=1
        ;;
  esac
  shift
done
 
# Parse environment variables
parse_env

# Assign alternate environment variables
NDCINC0MASO=${NDCINC0MAS} 
export NDCINC0MASO

NDCINC0MASN=${NDCINC0MAS}-NEW
export  NDCINC0MASN

echo "Convert NDCINC0MASO"
date
echo "NDCINC0MASO=${NDCINC0MASO}"
echo "NDCINC0MASN=${NDCINC0MASN}"
submit_ndcincconvert
echo  "   RET_CODE=$RETVAL "

date

exit $RETVAL
