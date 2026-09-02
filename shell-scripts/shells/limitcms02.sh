#!/bin/ksh
#
# Program Name	: limitcms02.sh
# Description   : Recalculate Limits by Group for Medicare Part D       
#                 Command Line Arguments:
#                   -g Enter group range flag
#                   -p Enter prev recalc date
# Author	:Michael Paulus
# Date		: 02/01/06
# Modifications : 03/10/2006 - Changes for assigning LIMITCMS02 and LIMITCMS02KEY in env_var  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
GROUP_FLAG=0
PREV_DATE_FLAG=0
USER=""
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limitcms02.sh [-g] [-p]                     

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


# Submit limitcms02 program
submit_limitcms02()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/limitcms02 -s ${GROUP_FLAG}${PREV_DATE_FLAG}  
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


echo "Group-Cardholder Limit Report for Medicare Part D"
date
submit_limitcms02
date

exit 0
