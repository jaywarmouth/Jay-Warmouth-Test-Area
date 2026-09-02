#!/bin/ksh
#
# Program Name	: claim59pcp.sh
# Description   : Post PCP's and PHO's    
#                 Command line arguments:
#                 -c County only switch
#                 -b Input Batch range
#                 -f <filename> Assign alternate CLAIM00MAS file
# Author	: Debbie Wilson                 
# Date		: 03/14/00
# Modifications : 03/22/00 - Added logic for county only switch & batch range.         
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
COUNTY_ONLY=0
BATCH=""
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim59pcp.sh [-c] [-b <batchrange> ] [-f <filename>]

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
# Submit claim59pcp program
submit_claim59pcp()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/claim59pcp -s ${COUNTY_ONLY} -a ${BATCH}
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
         BATCH=$1
         ;;
    -c) COUNTY_ONLY=1
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


echo Set Period Ending Dates
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
date
submit_claim59pcp
date

exit 0
