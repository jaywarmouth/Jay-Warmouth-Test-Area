#!/bin/sh
#
# Program Name	: limitmerge.sh 
# Description   : Merge lifetime Limit work file with Limit Master
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Peggy Voytilla 
# Date		: 01/06/2017
# Modifications : 01/06/2017 - Initial created                
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
DATETM=`date +%Y%m%d-%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limitmerge.sh [-t]

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
	  echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


# Submit limitmerge program
submit_limitmerge()

{
      runcobol ${OBJ_DIR}/limitmerge -a ${TEST_MODE}  
	RETVAL=$?
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

# Assign alternate environment variables

FG4AUD=/usr/files/conversions/LIMITMERGEAUD-${DATETM}
export FG4AUD
 
LIMITARMAS=/usr/files/conversions/LIMITARMAS
 export LIMITARMAS 

LIMITARCSV=/usr/files/conversions/LIMITARCSV-${DATETM}.csv               
 export LIMITARCSV

echo "LIMIT00MAS FIELD/FILE EXPANSION" 
date
echo "TEST_MODE=${TEST_MODE}"
echo "LIMIT00MAS=${LIMIT00MAS}"
echo "LIMITARMAS=${LIMITARMAS}"
echo "LIMITARCSV=${LIMITARCSV}"
echo "FG4AUD=${FG4AUD}"

submit_limitmerge 
echo  "   RETVAL=$RETVAL "
date

exit $RETVAL
