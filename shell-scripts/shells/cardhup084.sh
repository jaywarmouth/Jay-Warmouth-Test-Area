#!/bin/ksh
#
# Program Name  : cardhup084.sh
# Description   : Update CARDHOLDERS based on input file for 14006-1
#		  Command Line Arguments:
#		  -f <input file>
# Author        : Joe Novicky
# Date          : 11/26/2014
# Modifications : 07/21/2015 - updates for production version
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardhup084.sh -f <input file>

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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


# Submit cardhup084 program
submit_cardhup084()
{
        runcobol ${OBJ_DIR}/cardhup084  
	RETVAL=$?
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
	usage
fi
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FILE_FLAG=1
	FILE=$1
	;;
     *) usage
	;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE_FLAG} = 1 ]
then
        CARD084UPD=${FILE}
        export CARD084UPD
else
	usage
fi

FG4AUD=/usr/lnk/audit/CRDAUD
export FG4AUD


echo "Update cardh00mas from file with provided input file"
date
echo "EXPORT PATHS:"
echo "   CARD084UPD=$CARD084UPD"
echo "   FG4AUD=$FG4AUD"
submit_cardhup084
date

exit ${RETVAL}
