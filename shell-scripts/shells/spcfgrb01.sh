#!/bin/ksh
#
# Program Name  : spcfgrb01.sh
# Description   : Warehouse SPCFGRB01 Extract
#		  Command Line Arguments: None
#                 
#                 Program uses no switches.
# Author        : Janice Lanzo
# Date          : 07/20/15
# Modifications : 08/19/2015 - Prepare scipt for production use. (DME TT:9621-39)
#
#                
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

usage: spcfgrb01.sh 

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


# Submit spcfgrb01 program
submit_spcfgrb01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/spcfgrb01  

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables

echo "SPCFG00MAS Extract for Warehouse"
date
echo "EXPORT PATHS:"
echo "   SPCFG00MAS=${SPCFG00MAS}"
echo "   SPCFGRB001=${SPCFGRB001}"
submit_spcfgrb01
date

exit 0
