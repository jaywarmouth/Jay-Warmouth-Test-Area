#!/bin/ksh
#
# Program Name	: pcp.sh
# Description	: Runs procedures that build PCP09KEY and PCP8000MAS
#		  shell/pcp09.sh and shell/pcp80.sh
# Author	: Linda S. Jefferis
# Date		: 09/20/1999
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pcp.sh 

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

${SHELL_DIR}/pcp09.sh > ${RPT_DIR}/pcp09 2>&1
${SHELL_DIR}/pcp80.sh > ${RPT_DIR}/pcp80 2>&1

exit 0
