#!/bin/sh
#
# Program Name	: cardhup080.sh
# Description	: Cardholder Matrix Load
#                 Command Line Arguments:
#                 -l <sys#>  Process one system only
#                 -m Super script inv month <ccyymm>
#		  -y <yyyy>
# Author	: Linda Jefferis
# Date		: 02/25/97
# Modifications : 05/12/00 removed skip sort switch.
#               : 05/12/00 added super script month argument.
#               : 05/15/00 added system switch.
#		: 07/02/2008 - added display of inputted MONTH variable  (LSJ)
#                 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
MONTH=000000
SYS_FLAG=0
SYS=0000


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardhup080.sh [-l <sys#>] [-m <yyyymm>] -y <yyyy> 

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
    -m) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        MONTH=$1
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

# Assign alternate environment variables
if [ ${SYS_FLAG} = 1 ]
then
   CARDH80MAS=/usr/upd/crd_02/CARDH80MAS.${SYS}
   export CARDH80MAS
fi

echo "Cardholder Matrix Load"
echo "CARDH09KEY=$CARDH09KEY"
echo "CARDH80MAS=$CARDH80MAS"
date

echo MONTH=$MONTH

runcobol ${OBJ_DIR}/cardhup080 -s ${SYS_FLAG} -a ${MONTH}${YEAR}${SYS}

date

exit 0
