#!/bin/sh
#
# Program Name	: group42.sh
# Description   : TERMED SPONSORS
#                 No Switches:
# Author	: Janice Lanzo 
# Date		: 6/12/2017
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
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: group42.jl [-t]

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

	
# Submit group42 program
submit_group42()
{
      runcobol ${OBJ_DIR}/group42 -s ${TEST_MODE}
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

#Parse environment variables
parse_env

# Assign alternate environment variables

GRPSPONTRM=/usr/files/conversions/GRPSPONTRM
   export  GRPSPONTRM

   echo "CREATE GRPSPONTRM FILE WITH TERMED SPONSORS"
   date
   echo "EXPORT PATHS:"
   echo "GROUP00MAS=${GROUP00MAS}"
   echo "GRPSPONTRM=${GRPSPONTRM}"
   submit_group42
 
date

exit ${RETVAL}
