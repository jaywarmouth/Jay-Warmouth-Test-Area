#!/bin/ksh
#
# Program Name	: exclurb01.sh
# Description   : EXCLU00MAS extract to warehouse.
#                 Command line arguments:
# Author	: Mike Paulus
# Date		: 01/03/2012
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

usage: exclurb01.sh 

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

# Submit exclurb01 program
submit_exclurb01()
{
     runcobol ${OBJ_DIR}/exclurb01                 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env


echo "Extract of EXCLU00MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   EXCLURB001=${EXCLURB001}"
submit_exclurb01
date

exit 0
