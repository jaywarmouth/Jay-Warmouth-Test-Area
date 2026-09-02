#!/bin/sh
#
# Program Name	: diftb03.sh
# Description   : CREATE CSV REPORT OF DIFTB00MAS FILE
#                 Command line arguments:
#                  
# Author	: Janice Lanzo
# Date		: 08/23/2019
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
DATETM=`date +%Y%m%d%H%M%S`
RETVAL=0
OUT_DIR=/usr/lnk/wt/benefit-wt/DIFTB

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: diftb03.sh

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

# Submit diftb03 program
submit_diftb03()
{
        runcobol ${OBJ_DIR}/diftb03 
	RETVAL=$?
 
}

#
# Main routine
#

#Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

DIFTB00PRM=${HOME}/DIFTB00PRM
  export DIFTB00PRM

DIFTB03CSV=${OUT_DIR}/DIFTB03-${DATETM}.csv
 export DIFTB03CSV

submit_diftb03 

exit ${RETVAL}
