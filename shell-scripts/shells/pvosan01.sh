#!/bin/ksh
#
# Description   : UPDATE PVOSAN00MAS file.    
#                 Command line arguments:
#           
# Author	: Joe Novicky
# Date		: 03/24/2015
# Modifications : 04/01/2015 - Changes for production version 
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

usage: pvosan01.sh

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

# Submit pvsan01 program
submit_pvosan01( )
{
     runcobol ${OBJ_DIR}/pvosan01 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

HMSOSANIN01=$FILE_DIR/HMS_ORGANIZATION_SANCTIONS.txt
   export HMSOSANIN01


echo "Update PVOSAN00MAS from HMSOSANIN01"         
date
echo "EXPORT PATHS:"
echo "   HMSOSANIN01=$HMSOSANIN01"
echo "   PVOSAN00MAS=$PVOSAN00MAS"
submit_pvosan01

date

exit 0
