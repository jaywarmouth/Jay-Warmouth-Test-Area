#!/bin/ksh
#
# Program Name	: claim72bc.sh
# Description   : Claim File for BCBCMA 
#                 Command line arguments:
#                 -s Skip sort flag
# Author	: Linda S. Jefferis
# Date		: 06/06/96
# Modifications : 04/23/97 Added env_var & OBJ_DIR logic  (LSJ)
#                 04/23/97 Removed proc_audit  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SKIP_SORT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim72bc.sh [-s] 

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


# Submit claim72bc program
submit_claim72bc()
{
   if [ ${SKIP_SORT} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim72bc -s 1
     else
        runcobol ${OBJ_DIR}/claim72bc -s 0
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

# Assign alternate variables
CLAIM72KEY=${CLAIM72KEY}.BC
export CLAIM72KEY

echo Claim File for BCBCMA
date
submit_claim72bc 
date

exit 0
