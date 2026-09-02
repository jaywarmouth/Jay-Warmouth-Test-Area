#!/bin/ksh
#
# Program Name	: limit31.sh
# Description   : Recalculate Limits by Group       
#                 Command Line Arguments:
#                   -g Enter group range flag
#                   -p Enter prev recalc date
# Author	: Debbie Wilson
# Date		: 08/27/98
# Modifications : 04/08/99 Added logic for date & group flags.
#		: 02/24/2006 - Added umask command  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
GROUP_FLAG=0
PREV_DATE_FLAG=0
PRINT_DIR=/usr/lnk/po/misc
USER=""
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit31.sh [-g] [-p]                     

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


# Submit limit31 program
submit_limit31()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/limit31 -s ${GROUP_FLAG}${PREV_DATE_FLAG}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -g) GROUP_FLAG=1
        ;;
    -p) PREV_DATE_FLAG=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
AUDIT20MAS=/usr/lnk/audit/CLAIM02
export AUDIT20MAS 

umask 000

echo Group-Cardholder Limit Report
date
submit_limit31
date

exit 0
