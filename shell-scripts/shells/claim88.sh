#!/bin/ksh
#
# Program Name	: claim88.sh
# Description   : Electronic Fee 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -f Assign alternate CLAIM00MAS
# Author	: Linda S. Jefferis
# Date		: 04/12/96
# Modifications : 04/24/96 - Added logic for command line arguments
#                 02/28/97 - Added -f option
#                 02/28/97 - env_var, OBJ logic and removed proc_audit - LSJ
#                 11/22/04 - Added (twice-month) cycle (DW)
#                 04/05/05 - Added (week) cycle (DW)
#		: 09/18/2009 - Changes for switch to new check run process
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim88.sh [-s] [-f <filename>]
        -s              Skip Sort Flag                  optional
        -f <filename>   Alternate input Claims file     optional


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


# Submit claim88 program
submit_claim88()
{
     runcobol ${OBJ_DIR}/claim88 -s ${SKIP_SORT} 
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

# Stops change updates for RXODS
CHGFILEFLAG=N; export CHGFILEFLAG

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

echo "Electronic Fee"
date
echo "CLAIM00MAS=$CLAIM00MAS"
echo "CLAIM88KEY=$CLAIM88KEY"
submit_claim88 
date

exit 0
