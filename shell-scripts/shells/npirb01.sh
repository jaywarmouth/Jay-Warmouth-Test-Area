#!/bin/sh
#
# Program Name  : npirb01.sh
# Description   : Warehouse NPI00RB001 Extract
#		  Command Line Arguments: None
#                 
#                 Program uses no switches.
# Date          : 07/06/2018
# Modifications : 
#                
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

usage: npirb01.sh 

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


# Submit npirb01 program
submit_npirb01()
{
        runcobol ${OBJ_DIR}/npirb01  
	RETVAL=$?

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "NPI0000MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   NPI0000MAS=${NPI0000MAS}"
echo "   NPI00RB001=${NPI00RB001}"
submit_npirb01
date
echo "RETURN_CODE=$RETVAL"

exit $RETVAL
