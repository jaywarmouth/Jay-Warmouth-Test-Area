#!/bin/ksh
#
# Program Name	: ault_gt_file.sh
# Description	: Extract of Active Generic Table information for Aultcare
# Author	: Linda S. Jefferis
# Date		: 10/30/2008
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
FILE_PATH="/usr/lnk/tmp"
FLEX="/usr/lnk/flexgen"
EXTRACT_FILE="GDESC00WRK-PLAN"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ault_gt_file.sh 

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

umask 002

cd ${FLEX}

date
echo "      --> Running ohplaup001.cs"
${FLEX}/ohplaup001.cs
date

if test -s ${FILE_PATH}/${EXTRACT_FILE}
then
	echo ""
	echo "      --> Running ohgdspc001.cs"
	${FLEX}/ohgdspc001.cs
	date
else
	echo ""
	echo "-*> Possible error with ohplaup001.cs process."
	echo "-*> Did not run the ohgdspc001.cs process..."
fi


exit 0
