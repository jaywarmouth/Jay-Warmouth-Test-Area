#!/bin/ksh
#
# Program Name  : drugdis01.sh
# Description   : Update MSDDC Tape To DRUGDIS (DDI)
#		  Command Line Arguments:
# Author        : James Masluk
# Date          : 06/12/02
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

usage: drugdis01.sh 

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


# Submit drugdis01 program
submit_drugdis01()
{
        runcobol ${OBJ_DIR}/drugdis01 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Update MSDDC Tape To DRUGDIS (DDI)"
date
submit_drugdis01
date

exit 0
