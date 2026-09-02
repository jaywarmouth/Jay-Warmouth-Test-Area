#!/bin/ksh
#
# Program Name	: claim120.sh
# Description   : Post Marketing Differential Fees
#                 Command line arguments:
#                 -s Skip sort flag
#                 -f Assign alternate CLAIM00MAS
# Author	: Debbie Wilson               
# Date		: 08/14/01
#		: 01/24/2007 - Added logic for assigning alternate name for CLAIM120KEY  (LSJ)
#		: 09/23/2009 - Changes for switch to new check run process
#
# Variables Used:
OBJ_DIR="/usr/lnk/obj"
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SKIP_SORT=0
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim120.sh [-s] [-f <filename>]

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


# Submit claim120 program
submit_claim120()
{
      runcobol ${OBJ_DIR}/claim120 -s ${SKIP_SORT}000
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

echo "Post Marketing Differential Fee"
date
echo CLAIM00MAS=$CLAIM00MAS
submit_claim120 
date

exit 0
