#!/bin/ksh
#
# Program Name	: Affill04.sh 
# Description	: Add relationship and medicaid ID to indexed file.
# Author	: Mike Paulus
# Date		: 10/18/2007
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

usage: affill04.sh 

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

# Submit affill04 program
submit_affill04()
{   

           runcobol ${OBJ_DIR}/affill04  
           lp /usr/lnk/po/misc/PRINT-AFFILL04

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
submit_affill04
date

exit 0
