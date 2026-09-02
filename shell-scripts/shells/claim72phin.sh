#!/bin/ksh
#
# Program Name	: claim72phin.sh
# Description   : Claims to Tape Transfer 
#                 Command line arguments:
#                 -s Skip sort flag
# Author	: Linda S. Jefferis
# Date		: 04/26/96
# Modifications : 
#                 01/23/97 - CMS - TOOK OUT EXPORT OF COPAY00MAS=/usr/pdm/claims/COPAY00NEW
#               : 02/12/97 - Removed proc_audit logic - LSJ
#                 03/21/97 - Added env_var & OBJ_DIR logic - LSJ
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim72phin.sh [-s] 

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

# Submit claim72phin program
submit_claim72phin()
{
   if [ ${SKIP_SORT} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim72phin -s 1
     else
        runcobol ${OBJ_DIR}/claim72phin -s 0
   fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SKIP_SORT=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
CLAIM72KEY=${CLAIM72KEY}.PHIN
export CLAIM72KEY

echo Claims to Tape Transfer
echo Provident-Indemnity
date
submit_claim72phin 
date

exit 0
