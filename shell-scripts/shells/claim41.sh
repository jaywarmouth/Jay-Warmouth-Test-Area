#!/bin/ksh
#
# Program Name	: claim41.sh
# Description   : Physician Utilization Report 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -r Re-run program
#                 -t Sponsor run only
# Author	: Dave Tucci
# Date		: 03/14/2000
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
KEY_DIR=/usr/lnk/keys
LEVEL="null"
SKIP_SORT=0
RE_RUN=0
SPONSOR_RUN=0
BATCH="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim41.sh [-s] [-r <batch range>] [-t]

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

# Submit claim41 program
submit_claim41()
{
    if [ ${RE_RUN} = 1 ]
    then
       runcobol ${OBJ_DIR}/claim41 -s ${SKIP_SORT}${RE_RUN}${SPONSOR_RUN} -a ${BATCH}
    else
       runcobol ${OBJ_DIR}/claim41 -s ${SKIP_SORT}${RE_RUN}${SPONSOR_RUN}
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
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RE_RUN=1
        BATCH=$1
        ;;
    -s) SKIP_SORT=1
        ;;
    -t) SPONSOR_RUN=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

echo Physician Utilization Report
date
submit_claim41 
date

exit 0
