#!/bin/ksh
#
# Program Name	: claim04.sh
# Description   : Report for Audit of Claims 
#                 Command line arguments:
#                 -b Assign batch range and system# 
#                    batch range - 16 char.
#                    system# - 4 char. (0000 will do all systems)
#                 -f Assign alternate CLAIM00MAS
# Author	: Linda S. Jefferis
# Date		: 07/16/96
# Modification  : 04/23/97 Added env_var & OBJ_DIR logic  (LSJ)
#                 04/23/97 Removed proc_audit  (LSJ)
#		: 08/22/2006 - Changes for 4-digit system number  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
BATCH="null"
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim04.sh [-b <batch range><sys#>] [-f <filename>]

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

# Submit claim04 program
submit_claim04()
{
   if [ ${BATCH} = "null" ]
   then
     usage
   else
     runcobol ${OBJ_DIR}/claim04 -a ${BATCH}
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

echo Report for Audit of Claims
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CLAIM04MAS=$CLAIM04MAS"
submit_claim04 
date

exit 0
