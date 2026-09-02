#!/bin/ksh
#
# Program Name	: Affill03.sh 
# Description	: Create Intermediate Relationship File From NCPDP Tape.
# Author	: Mike Paulus
# Date		: 10/25/2006
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

usage: affill03.sh 

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

# Submit affill03 program
submit_affill03()
{   

           runcobol ${OBJ_DIR}/affill03  
           lp /usr/lnk/misc/PRINT-AFFILL03

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
submit_affill03
date

exit 0
