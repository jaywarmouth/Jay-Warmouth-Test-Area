#!/bin/ksh
#
# Program Name	: claim123.sh
# Description   : Claim Differential Report 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -c Type of cycle (pay|twice)
#		  -t <4-digit sys #> - Select system run type
#		  -r Rerun - reports on entire assigned CLAIM00MAS; ignores date and batch checks with SYSTE00MAS file.
#                 -f Assign alternate CLAIM00MAS
# Author	: James Masluk       
# Date		: 11/21/03
# Modifications : 
#               : 12/07/04 - Changes for newcycle runs  (DW)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
RERUN=0
SEL_SYS=0
FILE_FLAG=0
ARGUMENT=0000
PAY=0
TWICE=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim123.sh [-s] [-c pay|twice] [-t <system#>] [-r] [-f <filename>]

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

# Submit claim123 program
submit_claim123()
{
   if [ ${CYCLE} = "null" ]
   then
	usage
   else
      if [ ${SEL_SYS} = 1 ]
      then
        runcobol ${OBJ_DIR}/claim123 -s ${SKIP_SORT}${PAY}${TWICE}${SEL_SYS}${RERUN} -a ${ARGUMENT}
      else
        runcobol ${OBJ_DIR}/claim123 -s ${SKIP_SORT}${PAY}${TWICE}${SEL_SYS}${RERUN}
      fi
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
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CYCLE=$1
        validate_cycle
        ;;
    -t) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        ARGUMENT=$1
        SEL_SYS=1
        ;;
    -r) RERUN=1
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

echo Claim Differential Report
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"

#Submit the program
submit_claim123 

date

exit 0
