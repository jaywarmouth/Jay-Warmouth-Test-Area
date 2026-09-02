#!/bin/ksh
#
# Program Name	: mv-mon.sh
# Description	: Move mon-cycle files to rptarch
# Author	: Linda S. Jefferis
# Date		: 09/25/98
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/pdm/po"
RPTARCH="/usr/lnk/rptarch"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mv-mon.sh 

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

cd ${PO_DIR}
find . -name "*CA07*" -print -exec compress {} \;
find . -name "*CA08*" -print -exec compress {} \;
find . -name "*CA07*" -print  > pink1
find . -name "*CA08*" -print  >> pink1
cat pink1 | cpio -ocvdB > pink2
cd ${RPTARCH}
cpio -icvdB < ${PO_DIR}/pink2
rm ${PO_DIR}/pink?

exit 0
