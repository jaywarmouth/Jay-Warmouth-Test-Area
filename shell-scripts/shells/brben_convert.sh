#!/bin/sh
#
# Program Name  : brben_convert.sh
# Author        : gvernon 
# Date          : 08/05/2019
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0

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


# Submit BRBENCONVERT program
submit_brbenconvert()
{

      runcobol ${OBJ_DIR}/BRBENCONVERT
	RETVAL=$?

}


#
# Main routine

# Parse environment variables
parse_env

# Assign alternate environment variables
  BRBEN00MASN=${BRBEN00MAS}-NEW
  export BRBEN00MASN


echo CONVERT BRBEN00MAS FILE
date
echo ""
echo "   BRBEN00MAS=${BRBEN00MAS}"
echo "   BRBEN00MASN=${BRBEN00MASN}"


submit_brbenconvert
date
echo "RETURN_CODE=$RETVAL"

exit $RETVAL
