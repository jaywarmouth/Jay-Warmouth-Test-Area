#!/bin/sh
#
# Program Name  : cmsrb001.sh
# Description   : Creates new Warehouse Extract File (CMSHOSPMAS) 
#		  Command Line Arguments: None
#                 
# Author        : Lucy A. Caraballo
# Date          : 07/20/2015
# Modifications : Changes for production version (TT:13940-9)
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

usage: cmsrb001.sh 

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


# Submit cmsrb001 program
submit_cmsrb001()
{
        runcobol ${OBJ_DIR}/cmsrb001  
	RETVAL=$?

}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

# Assign alternate environment variables


echo "Extract of CMSHOSPMAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   CMSHOSPMAS=${CMSHOSPMAS}"
echo "   CMSRB001=${CMSRB001}"
submit_cmsrb001
date

exit ${RETVAL}
