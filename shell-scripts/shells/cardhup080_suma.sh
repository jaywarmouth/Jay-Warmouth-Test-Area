#!/bin/ksh
#
# Program Name	: cardhup080.sh
# Description	: Cardholder Matrix Load
#                 Command Line Arguments:
#                 -l <sys#>  Process one system only
#                 -m Super script inv month <ccyymm>
# Author	: Linda Jefferis
# Date		: 02/25/97
# Modifications : 05/12/00 removed skip sort switch.
#               : 05/12/00 added super script month argument.
#               : 05/15/00 added system switch.
#                 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
MONTH=0
SYS_FLAG=0
SYS=0000


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardhup080.sh [-l <sys#>] [-m] 

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
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
CARDH09KEY=/usr/lnk/grp/CARDH09KEY.suma
CARDH80MAS=/usr/lnk/rb_01/CARDH80MAS.sum
CARDH00MAS=/usr/lnk/crd_01/CAWRK00SUMA
export CARDH09KEY CARDH80MAS CARDH00MAS

echo Cardholder Matrix Load
date

if [ ${SYS_FLAG} = 1 ]
then
   runcobol ${OBJ_DIR}/cardhup080 -s ${SYS_FLAG} -a ${MONTH}${SYS}
else
   runcobol ${OBJ_DIR}/cardhup080 -s ${SYS_FLAG} -a ${MONTH}
fi

date

exit 0
