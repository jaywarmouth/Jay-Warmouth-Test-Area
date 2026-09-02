#!/bin/ksh
#
# Program Name  : team03.sh
# Description   : Update description to "UNKNOWN" on TEAM000MAS file 
#		  Command Line Arguments: None
#                 
# Author        : Lucy A. Caraballo
# Date          : 01/13/2016
# Modifications : 
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

usage: team03.sh 

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


# Submit team03 program
submit_team03()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/team03  

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "UPDATE TEAM DESCRIPTION TO UNKNOWN ON TEAM000MAS file"
date
echo "EXPORT PATHS:"
echo "   TEAM000MAS=${TEAM000MAS}"
submit_team03
date

exit 0
