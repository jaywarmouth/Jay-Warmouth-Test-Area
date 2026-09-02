#!/bin/sh
#
# Program Name	: bintyrb01.js
# Description   : Create bin type warehouse export         
#                 Command line arguments
#		  
#
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

usage: bintyrb01.sh

ENDOFUSAGE
  exit 1
}


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

	
# Submit bintyrb01 program
submit_bintyrb01()
{
      runcobol ${OBJ_DIR}/bintyrb01 
	RETVAL=$?
}

#
# Main routine
#
#Check command line validity, call usage if incorrect

# Parse environment variables
parse_env


echo "BIN Description Type WAREHOUSE EXPORT"

date
echo "EXPORT PATHS:"
echo "   BINTY00MAS=$BINTY00MAS"
echo "   BINTYRB001=$BINTYRB001"

submit_bintyrb01

date

exit $RETVAL
