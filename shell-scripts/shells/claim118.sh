#!/bin/ksh
#
# Program Name	: claim118.sh
# Description   : Pharmacy Payment Summary 
#                 Command line arguments:
#                 -s System <####>
#                 -c Chain <####>
#                 -p Paid date <ccyymmdd> 
#                 -f Assign alternate CLAIM00MAS
# Author	: James Masluk       
# Date		: 08/21/2000
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SYSTEM="null"
CHAIN="null" 
PAID_DATE="null"
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim118.sh [-s system] [-c chain] [-p paid_date] [-f <filename>]

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
# Submit claim118 program
submit_claim118()
{
            runcobol ${OBJ_DIR}/claim118 -a ${SYSTEM}${CHAIN}${PAID_DATE} 
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SYSTEM=$1
        ;;


    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CHAIN=$1
        ;;


    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        PAID_DATE=$1
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

echo Pharmacy Payment Summary

date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"

# Submit program
submit_claim118 

date

exit 0
