#!/bin/ksh
#
# Program Name	: limit_rollover.sh
# Description	: Makes backup copy of LIMIT00MAS and runs limit23.sh
# Author	: Linda S. Jefferis
# Date		: 12/14/2001
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit_rollover.sh 

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

date
cp /usr/lnk/crd_01/LIMIT00MAS /usr/lnk/sort/LIMIT00MAS.sav
if test $? -eq 0
then
   date
   /usr/lnk/shell/limit23.sh > /usr/lnk/rpt/limit23 2>&1
else
   echo "-*> Copy of LIMIT00MAS failed."
fi
date

exit 0
