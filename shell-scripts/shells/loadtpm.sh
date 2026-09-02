#!/bin/sh
#
# Program Name  : loadtpm.sh
# Description   : Load records from TPMINPUT file to TPM00MAS
#                 Command line arguments:
#                 -i Assign TPMINPUT filename
# Author        : Linda S. Jefferis
# Date          : 04/02/2015

# Variables:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: loadtpm.sh -i <TPMINPUT name>

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
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        TPMINPUT=$1
	export TPMINPUT
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

echo "FILES:"
echo "   TPMINPUT=$TPMINPUT"
echo "   TPM00MAS=$TPM00MAS"

runcobol ${OBJ_DIR}/LOADTPM
RETVAL=$?

date

exit $RETVAL 

