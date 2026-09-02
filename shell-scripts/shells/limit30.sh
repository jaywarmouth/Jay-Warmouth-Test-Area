#!/bin/ksh
#
# Program Name	: limit30.sh
# Description   : Recalculate Limits by Individuals
#                 Command Line Arguments:
#                   -r  Use REVOUTFILE
#                   -j  Use REJOUTFILE
#                   -p  Enter Previous recalc date
#                   -f  <filename> - Batch REVOUT File Run
#		    -a <Userclass Username>
#  To run using batch file input: 
#	limit30.sh -r -f <file directory and name> -a D <username>
# Author	: David Tucci
# Date		: 06/02/98
# Modifications : 02/24/2006 - Added umask command temporarily  (LSJ)
#		: 06/19/2010 - Commented umask command and took out remove of LIMIT30 file.  This file will now be assigned in env_var to ${HOME}.
#		: 06/24/2015 - Add batch file REVOUTFILE option (TT:13915-1)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
REV_OUT=0
REJ_OUT=0
BATCH_RUN=0
PREV_DATE_FLAG=0
USER=""
USERCLASS=""
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit30.sh [-r] [-j] [-p] [-f <filename>] -a ["userclass&username"]

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


# Submit limit30 program
submit_limit30()
{
        runcobol ${OBJ_DIR}/limit30 -s ${REV_OUT}${REJ_OUT}${PREV_DATE_FLAG}${BATCH_RUN} -a ${USERCLASS}${USER}'            '
 
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
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	BATCH_RUN=1
	IN_FILE=$1
	;;
    -a) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USERCLASS=$1
        USER=$2
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
AUDIT20MAS=/usr/lnk/audit/CLAIM02
export AUDIT20MAS 

if [ ${BATCH_RUN} = 1 ]
then
	REVOUTFILE=${IN_FILE}
	export REVOUTFILE
fi

#umask 000

echo Cardholder Limit Report
echo "   REVOUTFILE=$REVOUTFILE"
date
submit_limit30
date

exit 0
