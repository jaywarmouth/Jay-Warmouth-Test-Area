#!/bin/ksh
#
# Program Name	: pdecl03.sh
# Description   : PDE Data File Creation
#                 Command line arguments:
#                 -s Sponsor Number
#                 -y Submission Year
#                 -b Batch Range
#                 -t Test Mode
# Author	: James Masluk
# Date		: 12/02/08
# Modifications :

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
SPO_NUM="null"
SUB_YEAR="null"
BATCH_RANGE="                "

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdecl03.sh [-t] [-s <sponsor>] [-y <year>] [-b <batch-range>]

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


# Submit pdecl03 program
submit_pdecl03()
{
   if [ ${CYCLE} = "null" ]
   then
     usage
   else
      runcobol ${OBJ_DIR}/pdecl03 -s ${TEST_MODE} -a ${SPO_NUM}${SUB_YEAR}${BATCH_RANGE}
   fi
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
    -s) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SPO_NUM=$1
        ;;
    -y) shift
        if [ $# -le 0 ]
        then 
          usage
        fi
        SUB_YEAR=$1
        ;;
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        BATCH_RANGE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${TEST_MODE} = 1 ]
then
   OUTDAT0MAS=/usr/lnk/wrk/OUTDAT0TST
     export OUTDAT0MAS
fi


echo "PDE Data Export  - pdecl03"
date
submit_pdecl03 
date

exit 0
