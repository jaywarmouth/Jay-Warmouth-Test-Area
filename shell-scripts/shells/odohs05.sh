#!/bin/ksh
#
# Program Name	: odohs05.sh
# Description   : ODOHS Prior Auth changes Rpt
# Author	: Debbie Wilson         
# Date		: 09/18/00
# Modifications	: 05/15/2003 - Changes for new error checking  (LSJ)
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

usage: odohs05.sh  

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

# Assign alternate environment variables
ODOHS00TRA=/usr/lnk/medi/ODOHS00TRA
export ODOHS00TRA 

ODOHS00ERR=/usr/lnk/tmp/ODJFS-ERRORS
  export ODOHS00ERR

echo "ODOHS Prior Auth Changes Rpt"
date
runcobol ${OBJ_DIR}/odohs05
date

exit 0
