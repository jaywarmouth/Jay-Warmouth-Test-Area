#!/bin/sh
#
# Program Name	: cardhup081.sh
# Description	: Cardholder Matrix Load
#                 Command line arguments:
#                 -l <sys#>  Process one system only
# Author	: Linda Jefferis
# Date		: 02/26/97
# Modifications : 03/31/2000 - removed skip sort switch  (LSJ)
#		: 10/20/2006 - Changes for 4-digit system number  (LSJ)
#		: 01/03/2020 - Task #4534-12
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SYS_FLAG=0
SYS=0000
YEAR=`date +%Y`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardhup081.sh [-l <sys#>] -y <yyyy>

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
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -l) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SYS_FLAG=1
        SYS=$1
        ;;
    -y) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        YEAR=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate variables
if [ ${SYS_FLAG} = 1 ]
then
   CARDH81MAS=/usr/upd/crd_02/CARDH81MAS.${SYS}
   export CARDH81MAS
fi

echo Cardholder Matrix Load
date

runcobol ${OBJ_DIR}/cardhup081 -s ${SYS_FLAG} -a ${YEAR}${SYS}

date

exit 0
