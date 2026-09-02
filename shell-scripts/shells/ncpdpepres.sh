#!/bin/ksh
#
# Program Name	: Ncpdpepres.sh
# Description	: Update EPRES00MAS and create extract for the Warehouse.    
# Author	: Mike Paulus
# Date		: 12/02/2009
# Modifications :                                                    
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

usage: ncpdpepres.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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


# Submit ncpdpepres program
submit_ncpdpepres()
{

           runcobol ${OBJ_DIR}/ncpdpepres   

}
#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

umask 000

# Assign alternate environment variables

date
submit_ncpdpepres
date

exit 0
