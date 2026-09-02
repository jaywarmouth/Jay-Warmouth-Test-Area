#!/bin/ksh
#
# Program Name	: limit07.sh
# Description	: Limit Record Rollover.
# Author	: Dave Tucci
# Date		: 12/17/96
# Modifications : 06/19/97 - LSJ - Added env_var & OBJ_DIR logic
#                 12/29/97 - CMH - Added AUDITS to shell
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
BIN=0
MEMBER=0
GROUP=0
USER=""

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit07.sh [-grp] [-mbr] [-bin] -a [user]

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

# Submit limit07 program
# SWITCH 1 - grp - ALL MEMBERS WITHIN A GROUP
# SWITCH 2 - mbr - EXECUTE FOR ONE MEMBER AT A TIME
# SWITCH 3 - bin - ONE MEMBER WITH BIN CHANGE
submit_limit07()
{
  if [ ${GROUP} = 1 ]
    then 
      runcobol ${OBJ_DIR}/limit07 -s 10000 -a ${USER}'           '
  fi
  if [ ${MEMBER} = 1 ]
    then 
      runcobol ${OBJ_DIR}/limit07 -s 01000 -a ${USER}'           '
  fi
  if [ ${BIN} = 1 ]
    then 
      runcobol ${OBJ_DIR}/limit07 -s 00100 -a ${USER}'           '
  fi
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
if [ $# -le 0 ]
then
  usage
fi
#
while [ $# -gt 0 ]
do
  case "$1"
  in
   -grp) GROUP=1
         ;;
   -mbr) MEMBER=1 
         ;;
   -bin) BIN=1 
         ;;
    -a) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        USER=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
FG4AUD=/usr/lnk/audit/LIMAUD
export LIMAUD

date
submit_limit07
date

exit 0
