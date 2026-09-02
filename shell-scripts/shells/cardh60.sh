#!/bin/ksh
#
# Description   : UNPACK EMBOSSOMAS FOR WAREHOUSE
#                 Command line arguments:
#           
# Author	: Joe Novicky
# Date		: 12/12/2013
# Modifications : 12/18/2013 - Updated for production version (LSJ)                                                           
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: 	cardh06.sh

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

submit_cardh60( )
{
     runcobol ${OBJ_DIR}/cardh60  
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env


echo "Unload embossoomas"         
date
echo "EXPORT PATHS:"
echo "   EMBOSRB001=$EMBOSRB001"
echo "   EMBOS00MAS=$EMBOS00MAS"
submit_cardh60
date

exit 0
