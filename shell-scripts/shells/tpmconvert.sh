#!/bin/sh
#
# Program Name  : TPMCONVERT.cbl
# Date          : 12/24/2018

#                 
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="

OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
FIRST_PASS=1
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tpmconvert.sh

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


submit_tpmconvert()
{
     runcobol ${OBJ_DIR}/tpmconvert 
	RETVAL=$?
}

# Main routine
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1
        ;;
    -r) FIRST_PASS=1
        ;;
  esac
  shift
done
 
# Parse environment variables
parse_env

# Assign alternate environment variables
  
TPM00MASO=${TPM00MAS}
  export TPM00MASO

TPM00MASN=${TPM00MAS}-NEW
  export TPM00MASN

LOADTIMES=/tmp/LOADTIMES
  export LOADTIMES

echo "Convert TPM00MAS file"

echo "TPM00MASO=${TPM00MASO}"
echo "TPM00MASN=${TPM00MASN}"
echo "LOADTIMES=${LOADTIMES}"

submit_tpmconvert 

echo "RETCODE=$RETVAL"

date

exit $RETVAL
