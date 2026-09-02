#!/bin/sh
#
#
# Program Name	: rcpmasconvert01
# Description   : Converts fields in RCP0000MAS file 
#                 

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

usage: rcpmasconvert01.sh

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


# Submit rcpmasconvert01 program
submit_rcpmasconvert01()
{
     runcobol ${OBJ_DIR}/rcpmasconvert01 
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
  
RCP0000MASN=${RCP0000MAS}-NEW
export RCP0000MASN

RCP0000MASO=${RCP0000MAS}
export RCP0000MASO

DATAERROR=/tmp/RCP0000MAS-ERROR
export DATAERROR

echo "CONVERT RCP0000MAS NEW FILE"

date

echo "RCP0000MASN=${RCP0000MASN}"
echo "RCP0000MASO=${RCP0000MASO}"

submit_rcpmasconvert01

date

exit ${RETVAL}
