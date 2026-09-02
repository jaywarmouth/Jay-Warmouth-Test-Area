#!/bin/ksh
#
# Program Name  : crdaudit01.sh
# Description   : CARDH00MAS File Update Process
#		  Command Line Arguments:
#                 -s Skip Sort 
#                 -t Test Mode
#		  -f <Alt. CRDAUD0CUR>
#
# Author        : James Masluk
# Date          : 03/09/2006
# Modifications : 11/17/2009 - Added "-f" option  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SKIP_SORT=0
TEST_MODE=0
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: crdaudit01.sh [-s ] [-t] [-f <filename>]
        -s skip sort		optional
        -t test mode		optional
	-f <filename>		optional
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
# Submit crdaudit01 program
submit_crdaudit01()
{
     runcobol ${OBJ_DIR}/crdaudit01 -s ${SKIP_SORT}${TEST_MODE}
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
    -t) TEST_MODE=1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	FILE_FLAG=1
	FILE=$1
	;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${TEST_MODE} = 1 ]
then
   CARDH00MAS=/usr/lnk/wrk/ELGRT-CARDH
     export CARDH00MAS

   CRDAUD0CUR=/usr/lnk/wrk/CRDAUD0CUR
     export CRDAUD0CUR

   CRDAUD01KEY=/usr/lnk/wrk/CRDAUD01KEY
     export CRDAUD01KEY

fi

if [ ${FILE_FLAG} = 1 ]
then
	CRDAUD0CUR=${FILE}
	export CRDAUD0CUR
fi


echo "CRDAUD File Update Process"
date
submit_crdaudit01 
date

exit 0
