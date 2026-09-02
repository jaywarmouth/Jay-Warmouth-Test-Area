#!/bin/ksh
#
# Program Name	: claim57.sh
# Description   : Generic Utilization Report 
#                 Command line arguments:
#                 -c Type of run (pay or twice)
#                 -f Assign Alternate CLAIM56MAS
# Author	: Linda S. Jefferis
# Date		: 06/06/96
# Modifications : 04/23/97 Added env_var & OBJ_DIR logic  (LSJ)
#                 04/23/97 Removed proc_audit  (LSJ)
#               : 01/11/05 Added cycle flags and alternate file (DW)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
CYCLE="null"
PAY=0
TWICE=0
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim57.sh [-c pay|twice] [-f <filename>]

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
# Validate -c options
validate_cycle()
{  case ${CYCLE} in
     "pay")
        PAY=1
        ;;
     "twice")
        TWICE=1
        ;;
    *)  usage
         ;;
   esac
}
#
# Submit claim57 program
submit_claim57()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
     runcobol ${OBJ_DIR}/claim57 -s ${PAY}${TWICE} 
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
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CYCLE=$1
        validate_cycle
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM56MAS=${FILE}
   export CLAIM56MAS
else
   CLAIM56MAS=$CLAIM56MAS.${CYCLE}
   export CLAIM56MAS
fi

echo Generic Utilization Report
date
echo "EXPORT PATHS:"
echo "   CLAIM56MAS=${CLAIM56MAS}"
submit_claim57
date

exit 0
