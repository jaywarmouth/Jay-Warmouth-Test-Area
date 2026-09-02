#!/bin/ksh
#
# Program Name	: drug032.sh
# Description   : Drug Update for DPS Formulary Type Codes 32, 33, 34
# Author	: Christina Harris  
# Date		: 07/27/98
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

usage: drug032.sh 

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


#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign other variables
DRUGWRKMAS=/usr/lnk/drug/DRWRK00MAS.tc32-34
export DRUGWRKMAS


echo Drug Update for DPS Formulary
date
runcobol ${OBJ_DIR}/drug032 
date

exit 0
