#!/bin/ksh
#
# Program Name	: drug025.sh
# Description   : Drug Update for DPS Formulary Type Codes 16 and 25
# Author	: Christina Senediak
# Date		: 07/02/96
# Modifications : 08/26/97 (LSJ) Added env_var & OBJ_DIR logic
#                 08/24/98 (LSJ) Changed path of DRUG00MAS.type16
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

usage: drug025.sh 

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
DRUGWRKMAS=/usr/lnk/drug/DRUG00MAS.type16
export DRUGWRKMAS


echo Drug Update for DPS Formulary
date
runcobol ${OBJ_DIR}/drug025 
date

exit 0
