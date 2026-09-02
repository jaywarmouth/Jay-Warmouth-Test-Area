#!/bin/ksh
#
# Program Name	: crdhms01
# Description	: Cardholder/Eligibility data file to HMS for Medicaid comparison
#		  Command Line:
#		  -t - Test Mode Flag
# Author	: Linda S. Jefferis
# Date		: 08/10/2010
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: crdhms01.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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
    -t) TEST_MODE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

SPONS00TMP=/tmp/SPONS00TMP; export SPONS00TMP

date

# Run crdhms01
echo "SPONS00TMP=$SPONS00TMP"
runcobol ${OBJ_DIR}/crdhms01 -s ${TEST_MODE}

# cleanup
rm -f $SPONS00TMP

date

exit 0
