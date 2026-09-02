#!/bin/ksh
#
# Program Name	: brkdem01.sh
# Description   : BRKDEMB01 extract to warehouse.
#                 Command line arguments:
#           
# Author	: Dawn Engler
# Date		: 09/10/2014
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

usage: brkdem01.sh 

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

# Submit 01 program
submit_brkdem01()
{
     runcobol ${OBJ_DIR}/brkdem01  
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Extract of BRKDEM0MAS file for Warehouse"
date
echo "EXPORT PATHS:"
echo "   BRKDEMB01=$BRKDEMB01"
submit_brkdem01
date

exit 0
