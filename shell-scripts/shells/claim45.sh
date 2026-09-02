#!/bin/ksh
#
# Program Name	: claim45.sh
# Description	: Post Pharmacies Reversals for Non-Payment OFF-CYCLE
#                 Command Line Arguments:
#                 -s Skip sort flag
#                 -f Assign alternate CLAIM00MAS
# Author	: Linda S. Jefferis
# Date		: 04/12/96
# Modifications : 02/26/97 - Added logic for the Command line argruments - LSJ
#                 02/28/97 - Added env_var, OBJ_DIR logic; removed proc_audit - LSJ
#
# Variables Used:
OBJ_DIR="/usr/lnk/obj"
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_FLAG=0
SKIP_SORT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim45.sh [-s] [-f <filename>]

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

# Submit claim45 program
submit_claim45()
{
      runcobol ${OBJ_DIR}/claim45 -s ${SKIP_SORT} 
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
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

echo "Post Pharmacies Reversals for Non-Payment"

date
echo CLAIM00MAS=$CLAIM00MAS

# Submit claim45
submit_claim45

date

exit 0
