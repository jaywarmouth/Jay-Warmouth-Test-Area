#!/bin/ksh
#
# Program Name	: dr340brb01.sh  
# Description   : Extract DR340B0MAS file for Warehouse.    
#                 Command line arguments:
#		  -d <date-range>
#		  -o <alt DR340BRB001>
# Author	: William Kohuth
# Date		: 09/19/2017
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE_DIR=/usr/lnk/tmp
FILE_FLAG=0
DATERNGE="null"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dr340brb01.sh -d <date-range> -o <alt DR340BRB001>

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

# Submit dr340brb01 program
submit_dr340brb01( )
{
	if [ ${DATERNGE} = "null" ]
	then
		runcobol ${OBJ_DIR}/dr340brb01
		RETVAL=$?
	else
		runcobol ${OBJ_DIR}/dr340brb01 -a ${DATERNGE}
		RETVAL=$?
	fi
}

#
# Main routine
#
# Parse environment variables
parse_env

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -o) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FILE_FLAG=1
	FILE=$1
	;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATERNGE=$1
        ;;
  esac
  shift
done


# Assign alternate environment variables
if [ $FILE_FLAG = 1 ]
then
	DR340BRB001=$FILE
        export DR340BRB001
fi

date
echo "Extract DR340B00MAS for Warehouse"
echo "EXPORT PATHS:"
echo "   DR340B0MAS=$DR340B0MAS"
echo "   DR340BRB001=$DR340BRB001"

submit_dr340brb01

date
echo "RETVAL=$RETVAL"

exit $RETVAL

