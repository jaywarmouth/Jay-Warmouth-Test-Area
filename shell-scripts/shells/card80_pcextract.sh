#!/bin/ksh
#
# Program Name	: card80_pcextract.sh
# Description	: Runs procedure to do an extract on the CARDH80MAS file
# Author	: Linda S. Jefferis
# Date		: 05/18/2000
# Modifications : 06/04/2002 - Removed logic for BIGRED  (LSJ) 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_PATH="/usr/lnk/rb_01"
FLEX="/usr/lnk/flexgen"
EXTRACT_FILE="CARD80"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: card80_pcextract.sh 

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

rm -f ${FILE_PATH}/${EXTRACT_FILE}
cd ${FLEX}
echo "--> Extracting ${EXTRACT_FILE} - car80pc2.cs"
date
${FLEX}/car80pc2.cs
date

exit 0
