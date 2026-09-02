#!/bin/ksh
#
# Program Name	: gener06.sh        
# Description   : GENER00MAS O-WITH-Y UPDATE    
#                 Command line arguments:
# Author	: Debbie Wilson
# Date		: 10/12/01
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

usage: gener06.sh            

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

# Submit gener06 program            
submit_gener06()
{
    runcobol ${OBJ_DIR}/gener06 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "GENER06"
echo "HOSTNAME=$HOSTNAME"
date
submit_gener06             
date

exit 0
