#!/bin/ksh
#
# Description   : UPDATE PVONPI00MAS file.    
#                 Command line arguments:
#           
# Author	: Joe Novicky
# Date		: 03/24/2015
# Modifications : 04/01/2015 - updates for production version                                                           
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

usage: pvonpi01.sh 

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

# Submit pvonpi01 program
submit_pvonpi01( )
{
     runcobol ${OBJ_DIR}/pvonpi01 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
HORGNPIIN01=$FILE_DIR/HMS_ORGANIZATION_NPI.txt 
   export HORGNPIIN01


echo "Update PVONPI00MAS from HORGNPIIN01"         
date
echo "EXPORT PATHS:"
echo "   HORGNPIIN01=$HORGNPIIN01"
echo "   PVONPI00MAS=$PVONPI00MAS"
submit_pvonpi01
date

exit 0
