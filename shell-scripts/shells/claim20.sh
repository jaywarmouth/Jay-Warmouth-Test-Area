#!/bin/ksh
#
# Program Name	: claim20.sh
# Description   : Payment Itemization Report 
#                 Command line arguments:
#                 -a Audit run flag
#                 -f Assign alternate CLAIM00MAS
# Author	: Linda S. Jefferis
# Date		: 04/12/96
# Modifications : 04/24/96 - Added logic for command line arguments
#                 05/10/96 - Added -f option
#               : 02/12/97 - Removed proc_audit logic - LSJ
#                 02/28/97 - env_var, OBJ_DIR logic - LSJ
#		: 05/03/2005 - Changes for new week-cycle  (LSJ)
#		: 09/18/2009 - Changes for switch to new check run process
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0
SKIP_SORT=0
AUDIT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim20.sh [-a] [-s] [-f <filename>]

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

# Submit claim20 program
submit_claim20()
{
      runcobol ${OBJ_DIR}/claim20 -s ${SKIP_SORT}${AUDIT}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -a) AUDIT=1
        ;;
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

if [ $AUDIT = 1 ]
then
   CLAIM20KEY=${CLAIM20KEY}-A;export CLAIM20KEY
fi


echo "Payment Itemization Report"

date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CLAIM20KEY=$CLAIM20KEY"

# Submit program
submit_claim20 

date

exit 0
