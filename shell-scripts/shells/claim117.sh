#!/bin/ksh
#
# Program Name	: claim117.sh
# Description   : Claims to File Transfer for Ultimed
#                 Command line arguments:
#                 -c Type of cycle (pay)
#                 -s Skip sort flag
#                 -f <filename> (set different CLAIM00MAS)
#		  -r <batch range>
# Author	: Dave Tucci
# Date		: 02/10/2000
# Modifications : 12/14/2007 - Add pay-cycle switch.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SKIP_SORT=0
PAY=0
RERUN=0
FILE_FLAG=0
BATCH="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim117.sh [-c pay] [-s] [-f <filename>] [-r <batch range>]

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

# Validate -c options
validate_cycle()
{  case ${CYCLE} in
     "pay")
        PAY=1
        ;;
    *)  usage
         ;;

   esac
}


# Submit claim117 program
submit_claim117()
{
    if [ ${RERUN} = 1 ]
    then
      runcobol ${OBJ_DIR}/claim117 -s ${SKIP_SORT}${RERUN}${PAY} -a ${BATCH}
    else
      runcobol ${OBJ_DIR}/claim117 -s ${SKIP_SORT}${RERUN}${PAY}
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
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN=1 
        BATCH=$1
        ;;
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
   CLAIM00MAS=${FILE}
   export CLAIM00MAS 
fi


echo "Claims to File Transfer - claim117"
echo Ultimed
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
submit_claim117 
date

exit 0
