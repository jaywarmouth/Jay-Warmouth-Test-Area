#!/bin/ksh
#
# Description   : UPDATE PVADD00MAS file.    
#                 Command line arguments:
#           
# Author	: Joe Novicky
# Date		: 11/15/2013
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

submit_pvdea01( )
{
     runcobol ${OBJ_DIR}/pvadd01  
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables

HMSADDIN01=$FILE_DIR/HMS_Address.txt
   export HMSADDIN01


echo "Update PVADD00MAS from HMSADDIN01"         
date
echo "EXPORT PATHS:"
echo "   HMSADDIN01=$HMSADDIN01"
echo "   PVADD00MAS=$PVADD00MAS"
submit_pvdea01
date

exit 0
