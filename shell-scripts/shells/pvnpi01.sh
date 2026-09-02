#!/bin/ksh
#
# Description   : UPDATE PVNPI00MAS file.    
#                 Command line arguments:
#           
# Author	: Joe Novicky
# Date		: 10/24/2013
# Modifications :                                                            
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

usage: pvdea01.sh 

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

# Submit pvnpi01 program
submit_pvnpi01( )
{
     runcobol ${OBJ_DIR}/pvnpi01 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
HMSNPIIN01=$FILE_DIR/HMS_Practitioner_Profile.txt
   export HMSNPIIN01


echo "Update PVNPI00MAS from HMSNPIIN01"         
date
echo "EXPORT PATHS:"
echo "   HMSNPIIN01=$HMSNPIIN01"
echo "   PVNPI00MAS=$PVNPI00MAS"
submit_pvnpi01
date

exit 0
