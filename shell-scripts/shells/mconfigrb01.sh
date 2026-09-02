#!/bin/sh
#
# Program Name  : mconfigrb01.sh
# Description   : Warehouse MCONFRB001 Extract
#		  Command Line Arguments: None
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

usage: mconfigrb01.sh 

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


# Submit mconfigrb01 program
submit_mconfigrb01()
{
        runcobol ${OBJ_DIR}/mconfigrb01  
	RETVAL=$?

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "MCONFIGMAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   MCONFIGMAS=${MCONFIGMAS}"
echo "   MCONFRB001=${MCONFRB001}"
submit_mconfigrb01
date
echo "RETURN_CODE=$RETVAL"

exit $RETVAL
