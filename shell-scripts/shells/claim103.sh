#!/bin/ksh
#
# Program Name  : claim103.sh
# Description   : Pulls unpaid claims to work file by batch range.
#                 Uses by default, system 99 off-cycle beg. & ending batches.
#                 Command line arguments:
#                 -o Output filename
#                 -f Assign alternate CLAIM00MAS
# Author        : Dave Tucci      
# Date          : 04/25/97
# Modifications : 04/29/97 - Added env_var & OBJ_DIR logic  (LSJ)
#		: 10/07/2009 - Added the assigning of the INLGWRKMAS file
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE_FLAG=0
OUTPUT_FILE="null"
CLWRK_PATH="/usr/lnk/claims"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim103.sh [-o <filename>] [-f <filename>]

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
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTPUT_FILE=$1
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
CLWRK00MAS=${OUTPUT_FILE}
export CLWRK00MAS
INLGWRKMAS=${INLGWRKMAS}-C
export INLGWRKMAS


# Submit program
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CLWRK00MAS=$CLWRK00MAS"
echo "   INLGWRKMAS=$INLGWRKMAS"

if [ ${OUTPUT_FILE} = "null" ]
then
  usage
else
  cp ${CLWRK0NULL} ${CLWRK00MAS}
  runcobol ${OBJ_DIR}/claim103
fi

date

exit 0
