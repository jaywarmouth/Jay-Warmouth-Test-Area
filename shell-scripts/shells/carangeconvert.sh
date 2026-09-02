#!/bin/sh
#
# Script Name	: carangeconvert.sh
# Program Name	: carangeconvert.cbl
# Description   : Convert and Expand Key field in CARANGEMAS file 
#                 
# Author	: Patrick Murphy
# Date		: 02/23/2026
# Modifications : 
# TD-13739 - PDMI 2026 - CARANGEMAS - Halo 88087 - conversion program

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

usage: carangeconvert.sh

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


# Submit carangeconvert program
submit_carangeconvert()
{
     runcobol ${OBJ_DIR}/carangeconvert 
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

CARANGEMASN=${CARANGEMAS}-NEW
export CARANGEMASN

CARANGEMASO=${CARANGEMAS}
export CARANGEMASO


echo "CONVERT CARANGEMAS NEW FILE"

date

echo "CARANGEMASN=${CARANGEMASN}"
echo "CARANGEMASO=${CARANGEMASO}"
submit_carangeconvert

date

exit ${RETVAL}
