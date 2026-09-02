#!/bin/ksh
#
# Program Name	: cla55_rbextract.sh
# Description	: Runs procedure to do an extract on the CLAIM55MAS file
# Author	: Linda S. Jefferis
# Date		: 05/18/2000
# Modifications : 05/15/2002 - Changes for no longer updating Redbrick(Bigred) 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_PATH="/usr/lnk/rb_01"
FLEX="/usr/lnk/flexgen"
EXTRACT_FILE="CLAIM55"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cla55_rbextract.sh 

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
echo "--> Extracting ${EXTRACT_FILE} - cla55rb2.cs"
date
cla55rb2.cs
date

exit 0
