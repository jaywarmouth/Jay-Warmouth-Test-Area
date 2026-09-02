#!/bin/ksh
#
# Program Name	: mac001.sh         
# Description   : MAC0000MAS UPDATE             
#                 Command line arguments:
# Author	: Debbie Wilson
# Date		: 06/13/01
# Modifications : 08/22/2006 - Added HOSTNAME logic  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mac001.sh             

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

# Submit mac001 program            
submit_mac001()
{
    runcobol ${OBJ_DIR}/mac001 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "MAC001"
echo "HOSTNAME=$HOSTNAME"
date
submit_mac001              
date

exit 0
