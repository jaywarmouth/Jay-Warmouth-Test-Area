#!/bin/ksh
#
# Description   : UPDATE PVSAN00MAS file.    
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

usage: pvsan01.sh

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
submit_pvsan01( )
{
     runcobol ${OBJ_DIR}/pvsan01 

}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
HMSSANIN01=$FILE_DIR/HMS_Sanction.txt
   export HMSSANIN01


echo "Update PVSAN00MAS from HMSSANIN01"         
date
echo "EXPORT PATHS:"
echo "   HMSSANIN01=$HMSSANIN01"
echo "   PVSAN00MAS=$PVSAN00MAS"
submit_pvsan01
date

exit 0
