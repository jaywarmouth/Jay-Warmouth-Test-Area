#!/bin/ksh
#
# Program Name  : epres03.sh
# Description   : Formulary Data Load For RXHUB.
#		  Command Line Arguments (all are optional):
#		   -s Skip File flag
#                  -t Test Mode
# Author        : Linda Jefferis
# Date          : 02/12/2009
# Modifications : 12/11/2015 - TT12507-4
#		: 2/29/2016 - TT12507-7 updates.
#		: 11/4/2016 - General enhancement updates (e.g. removed obsolete sys option).
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_FILE=0
TEST_MODE=0
RETVAL=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: epres03.sh [-s] [-t] [-c <#### - sys#>]

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


# Submit epres03 program
submit_epres03()
{
        runcobol ${OBJ_DIR}/epres03 -s ${SKIP_FILE}${TEST_MODE} 
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
    -s) SKIP_FILE=1
        ;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
FORMULAPR=/usr/lnk/log/EPRES03_PARAMATER
CPIDX00MAS=/usr/lnk/tmp/EPRES03_CPIDX00MAS
NDCWK00MAS=/usr/lnk/tmp/EPRES03_NDCWK00MAS
DRUGWRKMAS=/usr/lnk/tmp/EPRES03_DRUGWRKMAS
export NDCWK00MAS CPIDX00MAS DRUGWRKMAS FORMULAPR


date
echo "Formulary Load For RXHUB"
echo ""
echo "   FORMULAPR=$FORMULAPR"
echo "   CPIDX00MAS=$CPIDX00MAS"
echo "   NDCWK00MAS=$NDCWK00MAS"
echo "   DRUGWRKMAS=$DRUGWRKMAS"

submit_epres03
date

exit ${RETVAL}
