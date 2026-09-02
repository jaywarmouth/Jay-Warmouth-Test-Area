#!/bin/ksh
#
# Program Name	: reconp2p.sh
# Description   : P2P Dummy File Creation for Aultcare
#                 Command line arguments:
#                 -p Type of file (pay, if not used then reconciliation)
#                 -r Create a Report
#                 -t Test Mode
# Author	: Sean Romigh
# Date		: 11/10/06
# Modifications :

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
PAY_FILE=0
TEST_MODE=0
REPORT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: reconp2p.sh -p -r -t 
	-p	pay file flag		optional
		(if this is not set, the default type is reconciliation)
	-r	report mode flag	optional
	-t	test mode flag		optional

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
	  echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."
}

# Submit reconp2p program
submit_reconp2p()
{
      runcobol ${OBJ_DIR}/reconp2p -s ${PAY_FILE}${TEST_MODE}${REPORT}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) PAY_FILE=1
        ;;
    -t) TEST_MODE=1
        ;;
    -r) REPORT=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables


if [ ${TEST_MODE} = 1 ]
then
   PDECL00MAS=/usr/lnk/wrk/PDECL00MAS.P2P
     export PDECL00MAS
fi


echo "P2P File Creation - reconp2p"
date
submit_reconp2p
date

exit 0
