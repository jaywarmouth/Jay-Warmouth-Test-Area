#!/bin/ksh
#
# Program Name  : pharm11.sh
# Description   : Load Pharmacies to PHNET File by Sys,Net#,Chain,State Code
# Author        : Christina Harris
# Date          : 11/17/97
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pharm11.sh 

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


# Submit pharm11 program
submit_pharm11()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/pharm11

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
date
submit_pharm11
date

exit 0
