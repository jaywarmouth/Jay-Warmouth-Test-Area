#!/bin/ksh
#
# Program Name	: drug070.sh
# Description   : Medispan Drug Application Flag and Source Update 
#		  Command Line Arguments:
# Author	: Vito Restaino
# Date		: 11/01/2010
# Modifications : 
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

usage: drug070.sh

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


echo "Drug Application Flag and Source Update"
echo "HOSTNAME=$HOSTNAME"
date
runcobol ${OBJ_DIR}/drug070 
date

exit 0
