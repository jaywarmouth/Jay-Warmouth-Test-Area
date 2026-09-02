#!/bin/ksh
#
# Program Name	: rebate10-special.sh
# Description   : Update field on CLAIM00MAS with manufacturer code for rebates.
#		  Program is hardcoded to only run Centocor/Pfizer/Wyeth id no manufacturer is entered.
#                 Command line arguments:
#                 -s Skip Sort
#                 -p Plan Level
#                 -c Contract Level
#                 -d Medicare D
#                 -m <manuf. abbrev>
#                 -t <System Number> (Must be 4 characters long)
# Author	: Linda Jefferis      
# Date		: 05/11/2011
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
PLAN_LEVEL=0
CONTRACT_LEVEL=0
MED_D=0
MAN=""
SYS=0000
ARGUMENT="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rebate10.sh [-s skip_sort] [-p plan_level] [-c contract_level] [-d] [-t <#### - sys#>] [-m <manuf. abbrev.>]

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

# Submit rebate10 program
submit_rebate10()
{
  runcobol ${OBJ_DIR}/rebate10-special -s ${SKIP_SORT}${PLAN_LEVEL}${CONTRACT_LEVEL}${MED_D} -a ${SYS}${MAN}'          ' 
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
    -p) PLAN_LEVEL=1
        ;;
    -c) CONTRACT_LEVEL=1
        ;;
    -d) MED_D=1
        ;;
    -m) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        MAN=$1
        ;;
    -t) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SYS=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${MED_D} = 1 ]
then
   MANRB00MAS=${MANRB00MAS}-MEDD
fi

echo "Rebate Files - REBATE10"
echo "MANRB00MAS=${MANRB00MAS}"
echo "MANDE00MAS=${MANDE00MAS}"
echo "MANUFACTURER:  ${MAN}"
date
submit_rebate10   
date

exit 0
