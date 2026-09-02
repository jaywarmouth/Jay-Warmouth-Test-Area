#!/bin/ksh
#
# Program Name	: claim80.sh
# Description   : HSTN Claims for the State 
#                 Command line arguments:
#                 -s Skip sort flag
# Author	: Linda S. Jefferis
# Date		: 06/19/96
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

usage: claim80.sh [-s] 

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


# Submit claim80 program
submit_claim80()
{
   if [ ${SKIP_SORT} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim80 -s 1
     else
        runcobol ${OBJ_DIR}/claim80 -s 0
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


echo HSTN Claims for the State
date
submit_claim80 
date

exit 0
