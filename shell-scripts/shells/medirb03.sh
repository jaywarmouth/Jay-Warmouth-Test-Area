#!/bin/ksh
#
# Program Name	: medirb03.sh
# Description   : MEDVAL00MAS extract to warehouse.
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

usage: medirb03.sh 

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

# Submit medirb03 program
submit_medirb03()
{
     runcobol ${OBJ_DIR}/medirb03 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "Extract of MEDVAL0MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   MEDVAL=${MEDVAL}"
submit_medirb03
date

exit 0
