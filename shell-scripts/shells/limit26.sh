#!/bin/ksh
#
# Program Name	: limit26.sh
# Description   : Recalculate Limits by Group
# Author	: David Tucci
# Date		: 05/12/97
# Modifications : 06/18/97 LSJ  Added env_var & OBJ_DIR logic
#                 06/30/97 DAT  Added USER to pass to COBOL Program
#                 08/21/97 CMH  Added USERCLASS to pass to COBOL Program
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
USERCLASS=""
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit26.sh -a ["userclass&username"]

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


# Submit limit26 program
submit_limit26()
{
        runcobol ${OBJ_DIR}/limit26 -a ${USERCLASS}${USER}'            '
 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -a) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USERCLASS=$1
        USER=$2
echo ${USER}${USERCLASS}
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
AUDIT20MAS=/usr/lnk/audit/CLAIM02
export AUDIT20MAS 

echo Cardholder Limit Report
date
submit_limit26 
date

exit 0
