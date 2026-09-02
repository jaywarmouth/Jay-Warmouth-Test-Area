#!/bin/ksh
#
# Program Name	: iefss01.cbl
# Description   : Initializes new fields in EFSS000MAS SNAP SHOT file 
#                 
# Author	: John Shrigley   
# Date		: 8/28/2016
# Modifications : 08/30/2016 - Changes for production version (TT16089-7)

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: iefss01.sh 

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
	  echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


# Submit iefss01 program
submit_iefss01()
{
     runcobol ${OBJ_DIR}/iefss01 
	RETVAL=$?

}

# Main routine#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
  
echo "Initialize EFSS000MAS new fields"
date
echo "EFSS000MAS=${EFSS000MAS}"
submit_iefss01 
date

exit $RETVAL
