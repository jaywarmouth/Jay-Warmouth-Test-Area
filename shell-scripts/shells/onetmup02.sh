#!/bin/sh
#
# Program Name	: onetmup02 
# Description   : Update member number on ONETM00MAS from cardholders orig claim
#                 Command line arguments
#                 Switches:
#                   -t Test mode (no ONETM00MAS file rewrites)
# Author	: Lucy Caraballo
# Date		: 9/22/2016
# Modifications :  
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
DATETM=`date +%Y%m%d%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: onetmup02.lc [-t]

ENDOFUSAGE
  exit 1
}


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

	
# Submit onetmup02 program
submit_onetmup02()
{
      runcobol ${OBJ_DIR}/onetmup02 -s ${TEST_MODE} 
	RETVAL=$?
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
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

         
ONETM02CSV=/usr/lnk/wt/oper-wt/misc/ONETM02CSV-${DATETM}.txt
   export ONETM02CSV


   echo "UPDATE ONETM00MAS FILE BASED"
   date
   echo "EXPORT PATHS:"
   echo "   FG4AUD=${FG4AUD}"
   echo "   ONETM00MAS=$ONETM00MAS"
   echo "   ONETM02CSV=$ONETM02CSV" 
   submit_onetmup02
	echo "RETVAL=$RETVAL"
   date

exit ${RETVAL}
