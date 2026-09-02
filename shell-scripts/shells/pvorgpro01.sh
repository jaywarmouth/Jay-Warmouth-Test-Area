#!/bin/ksh
#
# Description   : UPDATE PVOPRO00MAS file.    
#                 Command line arguments:
#           
# Author	: Joe Novicky
# Date		: 03/24/2015
# Modifications : 04/01/2015 - changes for production version
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE_DIR=/usr/lnk/tmp


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pvorgpro01.sh 

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

# Submit pvorgpro01 program
submit_pvorgpro01( )
{
     runcobol ${OBJ_DIR}/pvorgpro01 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

HORGPROIN01=$FILE_DIR/HMS_ORGANIZATION_PROFILE.txt 
   export HORGPROIN01


echo "Update PVOPRO00MAS from HORGPROIN01"         
date
echo "EXPORT PATHS:"
echo "   HORGPROIN01=$HORGPROIN01"
echo "   PVOPRO00MAS=$PVOPRO00MAS"
submit_pvorgpro01
date

exit 0
