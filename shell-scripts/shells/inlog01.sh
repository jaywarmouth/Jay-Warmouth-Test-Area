#!/bin/sh
#
# Program Name  : inlog01.sh
# Description   : Warehouse INLOG00MAS File Extract
#		  Command Line Arguments:
#		  -i <file path and name>  Assign alternate INLOG00MAS
#		  -o <file path and name>  Assign alternate INLOGRB001
# Author        : Kathy Ritzler
# Date          : 08/09/04
# Modifications : 10/14/2004 - Added -i and -o options  (LSJ)
#		: 10/14/2019 - added exit coding
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RB_FILE_FLAG=0
IN_FILE_FLAG=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: inlog01.sh -i <input filename> -o <output filename>
	<input filename>  alt. INLOG00MAS file		optional
	<output filename> alt. INLOGRB001 file		optional

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


# Submit inlog01 program
submit_inlog01()
{
        runcobol ${OBJ_DIR}/inlog01 
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
    -i) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	IN_FILE_FLAG=1
	IN_FILE=$1
	;;
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	RB_FILE_FLAG=1
	RB_FILE=$1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${RB_FILE_FLAG} = 1 ]
then
   INLOGRB001=${RB_FILE}
   export INLOGRB001
fi

if [ ${IN_FILE_FLAG} = 1 ]
then
   INLOG00MAS=${IN_FILE}
   export INLOG00MAS
fi

echo "INLOG00MAS Extract for Warehouse"
echo "     INLOG00MAS=$INLOG00MAS"
echo "     INLOGRB001=$INLOGRB001"
date
submit_inlog01
date

echo "EXIT CODE=$RETVAL"

exit $RETVAL
