#!/bin/ksh
#
# Program Name	: drug022.sh
# Description   : Update Type codes
# Author	: David Tucci
# Date		: 05/06/97
# Modifications : 08/22/2006 - Added HOSTNAME logic  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug022.sh 

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

echo "Updates Diabetic Supplies from tc 1/2/3 (tc29)"
echo "HOSTNAME=$HOSTNAME"
date
runcobol ${OBJ_DIR}/drug022 
date

exit 0
