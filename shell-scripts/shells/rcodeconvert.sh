#!/bin/sh
#
#
# Program Name	: RCODECONVERT.CBL
# Description   : Converts fields in RCODE00MAS file 
#                 
# Author	: Linda Jefferis  
# Date		: 7/09/2019
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

usage: rcodeconvert.sh

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


# Submit RCODECONVERT program
submit_rcodeconvert()
{
     runcobol ${OBJ_DIR}/rcodeconvert 
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
  
RCODE00MASN=${RCODE00MAS}-NEW
export RCODE00MASN

RCODE00MASO=${RCODE00MAS}
export RCODE00MASO


echo "CONVERT RCODE00MAS NEW FILE"

date

echo "RCODE00MASN=${RCODE00MASN}"
echo "RCODE00MASO=${RCODE00MASO}"

submit_rcodeconvert

date

exit ${RETVAL}
