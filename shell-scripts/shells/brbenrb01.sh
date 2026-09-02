#!/bin/sh
#
# Program Name	: brbenrb01.sh
# Description   : Create bin config warehouse export         
#		  
# Modifications : 10/19/2018 - TT18977-29 
#		: 02/13/2024 - sprint 465 - add BROPREJ file logic
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

usage: brbenrb01.sh 

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

	
# Submit brbenrb01 program
submit_brbenrb01()
{
      runcobol ${OBJ_DIR}/brbenrb01 
	RETVAL=$?
}

#
# Main routine
#
#Check command line validity, call usage if incorrect

# Parse environment variables
parse_env


echo "BIN CONFIG WAREHOUSE EXPORT"

date
echo "EXPORT PATHS:"
echo "   BRCFG00MAS=$BRCFG00MAS"
echo "   BRBEN00MAS=$BRBEN00MAS"
echo "   BROPREJMAS=$BROPREJMAS"
echo "   BRCHN00MAS=$BRCHN00MAS"
echo "   BRZIP00MAS=$BRZIP00MAS"
echo "   TBRBEN0MAS=$TBRBEN0MAS"
echo "   BRCFGRB001=$BRCFGRB001"
echo "   BRBENRB001=$BRBENRB001"
echo "   BRCHNRB001=$BRCHNRB001"
echo "   BRZIPRB001=$BRZIPRB001" 
echo "   TBRBENRB001=$TBRBENRB001" 
echo "   BROPREJRB01=$BROPREJRB01"

submit_brbenrb01

date

exit $RETVAL
