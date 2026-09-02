#!/bin/ksh
#
# Program Name	: claim09.sh
# Description   : Claims Itemization Report 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -f Alternate CLAIM00MAS filename
# Author	: Linda S. Jefferis
# Date		: 04/12/96
# Modifications : 04/24/96 - Added logic for command line arguments
#                 09/24/97 - Added env_var & OBJ_DIR logic  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SKIP_SORT=0
FILE_FLAG=0
ARGUMENT="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim09.sh [-s] [-f <filename>]

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


# Submit claim09rmb program
submit_claim09rmb()
{
   if [ ${SKIP_SORT} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim09rmb  -s 1
     else
        runcobol ${OBJ_DIR}/claim09rmb  -s 0
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
CLAIM09KEY=${CLAIM09KEY}.RMB
export CLAIM09KEY

echo RMB Reconciliation Report
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"

submit_claim09rmb 
date

exit 0
