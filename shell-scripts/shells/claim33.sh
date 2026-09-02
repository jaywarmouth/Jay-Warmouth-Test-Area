#!/bin/ksh
#
# Program Name	: claim33.sh
# Description   : Cardholder Review 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -t System Level
#                 -x Sponsor Level
#                 -g Group Level
# Author	: Linda S. Jefferis
# Date		: 07/12/96
# Modifications : 06/10/97 - LSJ - Added env_var & OBJ_DIR logic
#                 12/16/02 - JM  - Added System, Sponsor, and Group level switches.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SKIP_SORT=0
SYS_LEVEL=0
SPO_LEVEL=0
GRP_LEVEL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim33.sh [-s] [-t system level] [-x sponsor level] [-g group level] 

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


# Submit claim33 program
submit_claim33()
{
        runcobol ${OBJ_DIR}/claim33 -s ${SKIP_SORT}${SYS_LEVEL}${SPO_LEVEL}${GRP_LEVEL}  
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
    -t) SYS_LEVEL=1
        ;;
    -x) SPO_LEVEL=1
        ;;
    -g) GRP_LEVEL=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables


echo Cardholder Review
date
echo "EXPORT PATHS:"
echo "   CLAIM29MAS=$CLAIM29MAS"
echo "   CLAIM33MAS=$CLAIM33MAS"
submit_claim33 
date

exit 0
