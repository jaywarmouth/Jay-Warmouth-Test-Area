#!/bin/ksh
#
# Program Name	: rebate03.sh
# Description   : Provider Synergy Rebate File. (Monthly Run)
#		  Uses Fiscal Month start/stop batch range in the SYSTE00MAS file unless rerun switch is used.
#                 Command line arguments:
#		  -b <batch range> - Rerun switch for alternate batch range
# Author	: Christina Harris  
# Date		: 07/12/1999
# Modifications : 08/16/1999 - Added -b option  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RERUN=0
BATCH="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rebate03.sh [-b <batch range>]

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

#

# Submit rebate03 program
submit_rebate03()
{
  if [ ${RERUN} = 1 ]
  then
    runcobol ${OBJ_DIR}/rebate03 -s ${RERUN} -a ${BATCH}
  else
    runcobol ${OBJ_DIR}/rebate03 -s ${RERUN}
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
    -b) shift
	if [ $# -le 0 ]
        then
          usage
        fi
        BATCH=$1
	RERUN=1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Rebate File for Provider Synergies - REBATE03"
date
submit_rebate03 
date

exit 0
