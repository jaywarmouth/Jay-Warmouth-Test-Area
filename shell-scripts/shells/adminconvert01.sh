#!/bin/sh
#
# Program Name	: adminconvert01
# Description   : Convert ADMIN00MAS for changes in file
#                 Command Line Arguments: None
#                 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: adminconvert01
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


# Submit adminconvert01 program
submit_adminconvert01()
{
     runcobol ${OBJ_DIR}/adminconvert01
	RETVAL=$?

}

# Main routine#
 
# Parse environment variables
parse_env

# Assign alternate environment variables

ADMIN00MASO=${ADMIN00MAS}
export ADMIN00MASO
  
ADMIN00MASN=${ADMIN00MAS}-NEW
  export ADMIN00MASN


echo "CONVERT ADMIN00MAS NEW FILE"

date
echo "ADMIN00MASO=${ADMIN00MASO}"
echo "ADMIN00MASN=${ADMIN00MASN}"

submit_adminconvert01

date
echo "  RET_CODE=$RETVAL"

exit ${RETVAL}
