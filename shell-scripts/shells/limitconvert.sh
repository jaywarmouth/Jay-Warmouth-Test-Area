#!/bin/sh
#
# Program Name	: limitconvert.sh
# Description   : Convert old limit to expanded numeric field new limit file
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Debbe A. Adgate 
# Date		: 01/06/2017
# Modifications : 01/06/2017 - Initial created                
#		: 6/20/2017 - Changes for production version (LSJ)
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
RETVAL=0
TERMINFO=/usr/rmcobol/terminfo-d0.cfg
CONVINFO_DIR=/usr/files/conversions

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limitconvert.sh [-t]

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


# Submit limitconvert program
submit_limitconvert()
{
      runcobol ${OBJ_DIR}/limitconvert -C ${TERMINFO} -a ${TEST_MODE}  
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
 
LIMITFIX=${CONVINFO_DIR}/limitfix.txt
  export LIMITFIX

LIMIT00MASO=${LIMIT00MAS}
LIMIT00MASR=${LIMIT00MAS}
LIMIT00MASD=${LIMIT00MAS}
export LIMIT00MASO LIMIT00MASR LIMIT00MASD

LIMIT00MASN=${LIMIT00MAS}-NEW
 export LIMIT00MASN

LIMITDROPROLL=${CONVINFO_DIR}/LIMITDROPROLL-${DATETM}.txt
LIMITMEMFIX=${CONVINFO_DIR}/LIMITMEMFIX-${DATETM}.txt
LIMITMEMDUP=${CONVINFO_DIR}/LIMITMEMDUP-${DATETM}.txt
LIMITMEMBAD=${CONVINFO_DIR}/LIMITMEMBAD-${DATETM}.txt
LIMITMOVE0=${CONVINFO_DIR}/LIMITMOVE0-${DATETM}.txt
LIMITBADKEY=${CONVINFO_DIR}/LIMITBADKEY-${DATETM}.txt
LIMITMEMDROP=${CONVINFO_DIR}/LIMITMEMDROP-${DATETM}.txt
LIMITOINFOT=${CONVINFO_DIR}/LIMITOINFOT-${DATETM}.txt          
export LIMITDROPROLL LIMITMEMFIX LIMITMEMDUP LIMITMEMBAD LIMITMOVE0 LIMITBADKEY LIMITMEMDROP LIMITOINFOT

echo "LIMIT00MAS FIELD/FILE EXPANSION" 
date
echo "LIMIT00MASO=${LIMIT00MASO}"
echo "LIMIT00MASR=${LIMIT00MASR}"
echo "LIMIT00MASD=${LIMIT00MASD}"
echo "LIMIT00MASN=${LIMIT00MASN}"
echo "LIMITDROPROLL=${LIMITDROPROLL}"
echo "LIMITMEMFIX=${LIMITMEMFIX}"
echo "LIMITMEMDUP=${LIMITMEMDUP}"
echo "LIMITMEMBAD=${LIMITMEMBAD}"
echo "LMITMOVE0=${LMITMOVE0}"
echo "LIMITBADKEY=${LIMITBADKEY}"
echo "LIMITMEMDROP=${LIMITMEMDROP}"
echo "LIMITOINFOT=${LIMITOINFOT}"

submit_limitconvert 
echo  "   RETVAL=$RETVAL "
date

exit $RETVAL
