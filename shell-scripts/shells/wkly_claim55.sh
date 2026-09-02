#!/bin/ksh
#
# Program Name	: wkly_claim55.sh
# Description	: Runs claim55.sh and cla55_rbextract.sh
# Author	: Linda S. Jefferis
# Date		: 05/22/2000
# Modifications : 05/29/2003 - Added "pay-" to names of rpt files (LSJ) 
#		: 04/28/2004 - Removed the "lp" of the rpt files  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: wkly_claim55.sh 

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

${SHELL_DIR}/claim55.sh -c pay -m -y > ${RPT}/pay-claim55 2>&1
${SHELL_DIR}/cla55_rbextract.sh > ${RPT}/pay-cla55_rbextract 2>&1

exit 0
