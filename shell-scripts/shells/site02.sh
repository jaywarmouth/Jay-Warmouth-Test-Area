#!/bin/ksh
#
# Program Name	: site02.sh 
# Description   : Next available Site Number on SITE000MAS file
#                 Command line arguments:
#                 
#                 
# Author	: Linda Jefferis
# Date		: 07/02/2015
# Modifications :           
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: site02.sh

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{

    IFS=${OLDIFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
        IFS=${EQUAL}
        set $VAR
        NVAR=$1
        export ${NVAR}
#        if [ $? -ne 0 ]
#        then
#          echo "^G-*> Parse Error on Line: "${VAR}
#        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}


}

	
# Submit site02 program
submit_site02()
{
      runcobol ${OBJ_DIR}/site02 -k
	RETVAL="$?"
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
 

# Parse environment variables
parse_env


submit_site02
echo "This process will automatically exit in 5 seconds..."
sleep 5

exit ${RETVAL}
