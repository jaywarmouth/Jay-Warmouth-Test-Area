#!/bin/ksh
#
# Program Name	: field_init_201312.sh
# Description	: Off-hours Flexgen initialization procedure
# Author	: Linda S. Jefferis
# Date		: 12/06/2013
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: field_init_201312.sh 

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
parse_env


${SHELL_DIR}/ohclaup015.sh -f /usr/clm/d0/CLAIMS_qu1_12 >> ${RPT_DIR}/ohclaup015 2>&1
${SHELL_DIR}/ohclaup015.sh >> ${RPT_DIR}/ohclaup015 2>&1


exit 0
