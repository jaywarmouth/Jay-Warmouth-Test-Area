#!/bin/sh
#
#
# Program Name	: CLAIMCONVERT.CBL
# Description   : Converts fields in CLAIM00MAS file 
#                 
# Author	: Patrick Murphy  

 
# Date		: 07/02/2026
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claimconvert.pm

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


# Submit CLAIMCONVERT program
submit_claimconvert()
{
     runcobol ${OBJ_DIR}/CLAIMCONVERT -a F
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
  
CLAIM00MASN=${CLAIM00MAS}-NEW
export CLAIM00MASN

CLAIM00MASO=${CLAIM00MAS}
export CLAIM00MASO

MSGFILE="/tmp/msgfile-claim"
export MSGFILE

echo "CONVERT CLAIM00MAS NEW FILE"

date

echo "CLAIM00MASN=${CLAIM00MASN}"
echo "CLAIM00MASO=${CLAIM00MASO}"

submit_claimconvert

date

exit ${RETVAL}
