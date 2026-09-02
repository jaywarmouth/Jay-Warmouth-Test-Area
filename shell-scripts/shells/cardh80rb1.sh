#!/bin/sh
#
# Program Name	: cardh80rb1.sh
# Description	: Cardh80mas unload for warehouse - replace flexgen car80rb2.cs
#                 Command Line Arguments:
# Author	: J Novicky
# Date		: 12/12/14
# Modifications : 
#                 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardhup080.sh [-l <sys#>] [-m] 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    IFS=${OLDIFS}
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

# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

CARD80RB01=/usr/lnk/sqlimports/misc/CARD80RB
  export CARD80RB01 

echo "CARDH80MAS Warehouse Unload"
echo "CARDH80MAS=$CARDH80MAS"
echo "CARD80RB01=$CARD80RB01"
date

runcobol ${OBJ_DIR}/cardh80rb1

date

exit 0
