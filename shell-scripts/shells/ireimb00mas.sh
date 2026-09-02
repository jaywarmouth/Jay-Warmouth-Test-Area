#!/bin/ksh
# to run:
#         ireimb00mas.sh        (test mode update files)
#         ireimb00mas.sh -a    (test mode)
#
# Program Name	: ireimb00mas.sh
# Description   : Initialize REIMB00MAS new fields
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Debbe A. Adgate 
# Date		: 12/02/2014
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE="N"
PASS1="Y"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ireimb00mas.sh [-a]

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


# Submit ireimb00mas program
submit_ireimb00mas()
{
     runcobol ${OBJ_DIR}/IREIMB00MAS -a ${TEST_MODE}${PASS1}        
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
    -t) TEST_MODE="Y"
        ;;
    -m) PASS1="N"
        ;;
  esac
  shift
done
 
# Parse environment variables
parse_env

# Assign alternate environment variables
  
REIMB00MASI=${REIMB00MAS}
  export REIMB00MASI
REIMB00MASR=${REIMB00MAS}
  export REIMB00MASR
REIMBUPDTI=/tmp/REIMBUPDTI
  export REIMBUPDTI
REIMBUPDTO=/tmp/REIMBUPDTO
  export REIMBUPDTO

echo "Initialize REIMB00MAS new fields"
date
echo "REIMB00MASI=${REIMB00MASI}"
echo "REIMB00MASR=${REIMB00MASR}"
echo "REIMBUPDTI=${REIMBUPDTI}"
echo "REIMBUPDTO=${REIMBUPDTO}"
submit_ireimb00mas
echo  "   RETVAL=$? "
date

exit $RETVAL
