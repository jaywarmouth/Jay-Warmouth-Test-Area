#!/bin/ksh
#
# Program Name  : claim105.sh
#                 Command line arguments:
#                 -b Alternate Input Batch range
#                 -i Input filename (required)
#                 -f Assign alternate CLAIM00MAS
# Author        : Dave Tucci      
# Date          : 04/25/97
# Modifications : 04/29/97 - Added env_var & OBJ_DIR logic  (LSJ)
#		: 10/24/2005 - Changes for Linux  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE_FLAG=0
INPUT_FILE="null"
ARG_DATES_SW=0
ARG_DATES="null"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim105.sh [-i <filename>] [-f <filename>] [-b <batchrange> ] 

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
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        ARG_DATES=$1
        ARG_DATES_SW=1
        ;;
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INPUT_FILE=$1
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

# Assign alternate environment
if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi
CLWRK00MAS=${INPUT_FILE}
export CLWRK00MAS

# Submit program
date
echo "HOSTNAME=${HOSTNAME}"
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CLWRK00MAS=$CLWRK00MAS"

if [ ${INPUT_FILE} = "null" ]
then
  usage
else
  if [ ${ARG_DATES_SW} = 1 ]
  then
    runcobol ${OBJ_DIR}/claim105w -s 1 -a ${ARG_DATES}
  else
    runcobol ${OBJ_DIR}/claim105w 
  fi
fi

date

exit 0
