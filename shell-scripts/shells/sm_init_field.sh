#!/bin/ksh
#
# Program Name	: sm_init_field.sh
# Description   : Initialize new fields in small MAS files
#                
#          Command Line Arguments: None
#		-p Program Name
#		-t Test Mode  
#		-i Initialize Mode
#                 
# Author	: Dawn Engler
# Date		: 10/26/2015
# Modifications : 03/01/2017 - changed "-s" to "-a" on runcobol command.
#	DO NOT use this script for any "I*.cbl" programs that have the TEST_MODEprogrammed as a SWITCH instead of under LINKAGE section.
#


# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
PROGRAM=$1
INIT_FILE=`echo ${PROGRAM} | cut -c2-`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: sm_init_field.sh [program name] [-t] or [-i] 
        -t      Test Initalize Fields
        -i      Initialize New Fields

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


#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
	usage
fi


while [ $# -gt 1 ]
do
  case "$2"
  in
    -i) TEST_MODE=0
	;;
    -t) TEST_MODE=1
        ;;
    *) usage
	;;

  esac
  shift
done
 
# Parse environment variables
parse_env

echo "Initialize ${INIT_FILE} new fields"
date
echo "${INIT_FILE}=${PROGRAM}"

runcobol ${OBJ_DIR}/${PROGRAM} -a ${TEST_MODE} 
date

exit 0
