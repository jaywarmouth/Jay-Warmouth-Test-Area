#!/bin/ksh
#
# Program Name	: gpichg01.sh
# Description   : List Generic Tables for Gpi Changes
#                 Command line arguments:
#                 -s Skip sort flag
#                 -n New Gpi run                                
#                 -f Filename <filename> (Gpi Change File Name)
# Author	: Debbie Wilson            
# Date		: 05/24/00
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
NEW_GPI=0         
FILE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: gpichg01.sh [-s] [-n] [-f <filename>] 

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

# Submit gpichg01 program
submit_gpichg01()
{
     runcobol ${OBJ_DIR}/gpichg01 -s ${SKIP_SORT}${NEW_GPI}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -s) SKIP_SORT=1
        ;;
    -n) NEW_GPI=1           
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE} = "null" ]
then
   usage
else
   GPICH00SEQ=${FILE}
   export GPICH00SEQ
fi

echo "List Generic Tables for Gpi Changes"

date

# Submit program
echo "GPI CHANGES FOR GENERIC TABLES"
date
echo "EXPORT PATHS:"
echo "    GPICH00SEQ=$GPICH00SEQ"
submit_gpichg01

date

exit 0
