#!/bin/ksh
#
# Program Name	: gpichg02.sh
# Description   : List Step Tables for Gpi Changes
#                 Command line arguments:
#                 -s Skip sort flag
#                 -n Old Gpi to Primary Gpi
#                 -o Old Gpi to Secondary Gpi
#                 -p New Gpi to Primary Gpi
#                 -q New Gpi to Secondary Gpi 
#                 -f Filename <filename> (Gpi Change File Name)
# Author	: Christina Harris         
# Date		: 06/07/00
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
OLD_PRIM=0
OLD_SEC=0
NEW_PRIM=0
NEW_SEC=0
FILE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: gpichg02.sh [-s] [-n] [-o] [-p] [-q] [-f <filename>] 

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

# Submit gpichg02 program
submit_gpichg02()
{
     runcobol ${OBJ_DIR}/gpichg02 -s ${SKIP_SORT}${OLD_PRIM}${OLD_SEC}${NEW_PRIM}${NEW_SEC}
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
    -n) OLD_PRIM=1           
        ;;
    -o) OLD_SEC=1
        ;;
    -p) NEW_PRIM=1
        ;;
    -q) NEW_SEC=1
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

echo "List Step Tables for Gpi Changes"

date

# Submit program
echo "GPI CHANGES FOR STEP TABLES"
date
echo "EXPORT PATHS:"
echo "    GPICH00SEQ=$GPICH00SEQ"
submit_gpichg02

date

exit 0
