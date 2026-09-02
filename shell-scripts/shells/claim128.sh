#!/bin/ksh
#
# Program Name	: claim128.sh
# Description   : Statements and Reject forms for System 51
#                 Command line arguments:
#                 -c Type of cycle (pay, off, twice)
#                 -s Skip sort flag
#                 -f Assign an Alternate CLAIM00MAS
# Author	: James Masluk       
# Date		: 01/08/04
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
CYCLE="null"
SKIP_SORT=0
PAY=0
OFF=0
TWICE=0
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim128.sh [-c pay|off|twice] [-s] [-f <filename>]

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
     "off")
        OFF=1
        ;;
     "twice")
        TWICE=1
        ;;
    *)  usage
         ;;
   esac
}


# Submit claim128 program
submit_claim128()
{
   if [ ${CYCLE} = "null" ]
   then
      usage 
   else
      runcobol ${OBJ_DIR}/claim128 -s ${SKIP_SORT}${OFF}${PAY}${TWICE}
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

echo Statements and Reject forms
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"

# Submit the program
submit_claim128 

date

exit 0
