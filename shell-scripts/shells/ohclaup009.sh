#!/bin/ksh
#
# Program Name	: ohclaup009.sh
# Description	: Off-hours Claims initialization procedure
# Author	: Linda S. Jefferis
# Date		: 04/16/2010
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_PATH="/usr/lnk/flexgen"
FLEX="/usr/lnk/flexgen"
VFAXDIR=/usr/vsifax/spool;export VFAXDIR
PATH=$PATH:/usr/vsifax/bin:/usr/pdm/bin;export PATH


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ohclaup009.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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
#parse_env

CLAIM00MAS=/usr/lnk/clm_01/CLAIM00MAS
export CLAIM00MAS

cd ${FLEX}

date
echo "--> Starting - ohclaup009.cs"
${FLEX}/ohclaup009.cs

date
echo "--> Finished" 


exit 0
