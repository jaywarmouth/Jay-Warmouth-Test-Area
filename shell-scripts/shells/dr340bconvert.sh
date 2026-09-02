#!/bin/sh
#
# Program Name	: dr340bconvert.sh
# Description   : Rewrite DR340B0MAS with change-date alternate key
#                
#          Command Line Arguments: None
#          -t Test Mode  
#                 
# Author	: Dave Rudawsky
# Date		: 09/21/2017
# Modifications	: 10/31/2017 - TT:17539-12; Changes for production version
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dr340bconvert.sh [-t]

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


# Submit dr340bconvert program
submit_dr340bconvert()
{
      runcobol ${OBJ_DIR}/dr340bconvert -a ${TEST_MODE}  
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

DR340B0MASO=${DR340B0MAS}
  export DR340B0MASO 
DR340B0MASN=${DR340B0MAS}-NEW
  export DR340B0MASN
DR340BERR=/usr/lnk/drug/DR340BERR    
  export DR340BERR
echo "Convert DR340B0MAS"
date
echo "DR340B0MASO=${DR340B0MASO}"
echo "DR340B0MASN=${DR340B0MASN}"
echo "DR340BERR=${DR340BERR}"
submit_dr340bconvert
echo  "   RET_CODE=$RETVAL "

date

exit $RETVAL
