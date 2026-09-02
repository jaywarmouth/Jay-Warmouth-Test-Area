#!/bin/ksh
#
# Program Name	: medirb02.sh
# Description   : MEDNDC00MAS extract to warehouse.
#                 Command line arguments:
# Author	: Mike Paulus
# Date		: 09/25/08
# Modifications :                                                            
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: medirb02.sh 

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Submit medirb02 program
submit_medirb02()
{
     runcobol ${OBJ_DIR}/medirb02 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "Extract of MEDNDC0MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   MEDNDC=${MEDNDC}"
submit_medirb02
date

exit 0
