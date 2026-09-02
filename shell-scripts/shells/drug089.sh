#!/bin/ksh
#
# Program Name	: drug089.sh
# Description   : Medispan Drug Update ONE TIME SPECIAL REQUEST  
#		  (Drug Update - Field Specific from full Medispan input file)
#		  Command Line Arguments:
#		  -t test mode - no updates to drug00mas flag (optional)
#                   -i <input DRUG000TAP filename>
#                   -o <Output PRINTFILE report filename>
# Author	: Linda S. Jefferis
# Date		: 10/26/16
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
FILE_FLAG=0
OUTFILE_FLG=0
TEST_MODE=0
DATETM=`date +%Y%m%d%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug089.sh -t -i <input DRUG000TAP> -o <output PRINTFILE report>

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
    -t) TESTMODE_FLAG=1
        ;;
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE_FLG=1
        OUTFILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate variables

if [ ${FILE_FLAG} = 1 ]
then
        DRUG000TAP=${FILE}
else
        DRUG000TAP=/usr/lnk/tmp/DRUG000TAP
fi
export DRUG000TAP

if [ ${OUTFILE_FLG} = 1 ]
then
        PRINTFILE=${OUTFILE}
else
        PRINTFILE=/usr/lnk/tmp/DRUG089-${DATETM}.txt
fi
export PRINTFILE


echo "Drug Update - Field Specific from full Medispan input file"
echo "HOSTNAME=$HOSTNAME"
date
runcobol ${OBJ_DIR}/drug089 -s ${TEST_MODE} 
RETVAL=$?
echo "RETVAL=$RETVAL"
date

exit $RETVAL
