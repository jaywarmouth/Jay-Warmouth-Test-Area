#!/bin/sh
#
# Program Name  : teamrb01.sh
# Description   : Creates new Warehouse Extract File (TEAM000MAS) 
#		  Command Line Arguments: None
#                 
# Author        : Lucy A. Caraballo
# Date          : 01/05/2016
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

usage: teamrb01.sh 

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


# Submit teamrb01 program
submit_teamrb01()
{
        runcobol ${OBJ_DIR}/teamrb01  
	RETVAL=$?

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "Extract of TEAM000MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   TEAM000MAS=${TEAM000MAS}"
echo "   TEAMRB01=${TEAMRB01}"
submit_teamrb01
date

exit $RETVAL
