#!/bin/ksh
#
# Program Name	: convmktinv.sh
# Description	: Converts old format MKTINVFILE to new format file
#		  Command Line Arguments:
#		  -i <input filename> - MKTINVFILE filename
#		  -o <output filename> - MKTINV0NEW filename
# Author	: Linda S. Jefferis
# Date		: 01/27/99
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/programs/obj"
IN_FILE="null"
OUT_FILE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: convmktinv.sh [-i <input file>] [-o <output file>]

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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

#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        else
          IN_FILE=$1
        fi
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        else
          OUT_FILE=$1
        fi
        ;;
  esac
  shift
done
    

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${IN_FILE} = "null" ]
then
   usage
else
   MKTINVFILE=${IN_FILE}
   export MKTINVFILE
fi
if [ ${OUT_FILE} = "null" ]
then
   usage
else
   MKTINV0NEW=${OUT_FILE}
   export MKTINV0NEW
fi

# Submit convmktinv
date
echo "MKTINVFILE conversion"
runcobol ${OBJ_DIR}/convmktinv
date

exit 0
