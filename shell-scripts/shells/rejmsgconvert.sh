#!/bin/sh
#
#
# Program Name	: rejmsgconvert.cbl
# Description   : Converts and Expands Key field in REJMSG0MAS file 
#                 
# Author	: Lucy A. Caraballo
# Date		: 7/24/2024
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

usage: rejmsgconvert.sh

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


# Submit rejmsgconvert program
submit_rejmsgconvert()
{
     runcobol ${OBJ_DIR}/rejmsgconvert 
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
  
REJMSG0MASN=${REJMSG0MAS}-NEW
export REJMSG0MASN

REJMSG0MASO=${REJMSG0MAS}
export REJMSG0MASO


echo "CONVERT REJMSG0MAS NEW FILE"

date

echo "REJMSG0MASN=${REJMSG0MASN}"
echo "REJMSG0MASO=${REJMSG0MASO}"

submit_rejmsgconvert

date

exit ${RETVAL}
