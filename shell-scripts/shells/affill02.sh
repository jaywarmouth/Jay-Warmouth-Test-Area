#!/bin/ksh
#
# Program Name	: Affill02.sh 
# Description	: Update Affil00mas From NCPDP Relationship Demographic Tape.
# Author	: Mike Paulus
# Date		: 11/01/2006
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

usage: affill02.sh 

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


# Submit affill02 program
submit_affill02()
{

           runcobol ${OBJ_DIR}/affill02  
           lp /usr/lnk/misc/PRINT-AFFILL02

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
submit_affill02
date

exit 0
