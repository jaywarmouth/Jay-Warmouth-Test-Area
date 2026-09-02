#!/bin/ksh
#
# Program Name	: limitcms01.sh
# Description   : Recalculate TROOP by Individuals for Medicare Part D
#                 Command Line Arguments:
#                   -r  Use REVOUTFILE
#                   -j  Use REJOUTFILE
#                   -p  Enter Previous recalc date
# Author	: Michael Paulus
# Date		: 12/30/05
# Modifications : 01/05/07 - MP - Add switch for previous recalc date. 
#		: 10/03/2018 - TT18645-21; change runcobol statement.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
REV_OUT=0
REJ_OUT=0
PREV_DATE_FLAG=0
USER=""
USERCLASS=""
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limitcms01.sh [-r] [-j] [-p] -a ["userclass&username"]

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


# Submit limitcms01 program
submit_limitcms01()
{
        runcobol ${OBJ_DIR}/limitcms01 -a ${REV_OUT}${REJ_OUT}${PREV_DATE_FLAG}${USERCLASS}${USER}'            '  
 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -r) REV_OUT=1
        ;;
    -j) REJ_OUT=1
        ;;
    -p) PREV_DATE_FLAG=1
        ;;
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
submit_limitcms01
date

exit 0
