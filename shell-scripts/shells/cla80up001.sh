#!/bin/ksh
#
# Program Name	: cla80up001.sh
# Description	: CLAIM80 Audit Update
#                 Command Line Arguments:
#                 -s Skip sort flag
#                 -n <filename> Switch for new CLAIM80MAS file
#                 -g Group Range (<start><end> 8-digits each)
#                 -y System Range (<start><end> 4-digits each)
# Author	: Linda Jefferis
# Date		: 09/26/97
# Modifications :
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
NEW_FILE=0
GRP_START=0000000000000000
GRP_END=0000000000000000
SYS_START=0000
SYS_END=0000

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cla80up001.sh [-s] [-n <filename>] [-g <start grp> <end grp>] [-y <start ys> <end sys>]

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
    -s) SKIP_SORT=1
        ;;
    -n) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        NEW_FILE=1
        FILE=$1
        ;;
    -g) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        GRP_START=$1
        GRP_END=$2
        ;;
    -y) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SYS_START=$1
        SYS_END=$2
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${NEW_FILE} = 1 ]
then
   CLAIM80MAS=${FILE}
   export CLAIM80MAS
fi


echo Cardholder Matrix Load
date

echo ${CLAIM80MAS}
echo ${GRP_START}
echo ${GRP_END}
echo ${SYS_START}
echo ${SYS_END}
if [ ${SKIP_SORT} = 1 ]
  then
     runcobol ${OBJ_DIR}/cla80up001 -s 1${NEW_FILE} -a ${GRP_START},${GRP_END},${SYS_START},${SYS_END}
  else
     runcobol ${OBJ_DIR}/cla80up001 -s 0${NEW_FILE} -a ${GRP_START},${GRP_END},${SYS_START},${SYS_END}
fi

date

exit 0
