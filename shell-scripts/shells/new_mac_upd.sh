#!/bin/ksh
#
# Program Name	: new_mac_upd.sh
# Description	: Makes backup copy of MAC0000MAS and runs mac001.sh
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

usage: new_mac_upd.sh 

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
cp /usr/lnk/drug/MAC0000MAS /usr/lnk/sort/MAC0000MAS.sav
if test $? -eq 0
then
   date
   /usr/lnk/shell/mac001.sh > /usr/lnk/rpt/mac001.year 2>&1
else
   echo "-*> Copy of MAC0000MAS failed"
fi
date

exit 0
