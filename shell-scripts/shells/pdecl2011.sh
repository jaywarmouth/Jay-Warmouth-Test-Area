#!/bin/ksh
#
# Program Name	: pdecl2011.sh
# Description   : PDE File Creation
#                 Command line arguments:
#                 -s Skip sort flag
#                 -r Resubmit flag
#                 -b <Batch Range> (16-characters)
#                 -t Test Mode flag
#		  -x Select-year flag
#			(Select only PDEs with Rx date equal to Sub Year)
#                 -y <Sub Year> (4-digits)
# Author	: Peggy Voytilla
# Date		: 10/15/2010
# Modifications : 02/01/2011 - Modifications for production mode  (LSJ)
#		: 07/09/2015 - TT:12681-45 - Add SELECT_YEAR flag logic.

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
TEST_MODE=0
BATCH_RANGE="null"
SUB_YEAR="null"
RESUB=0
SELECT_YEAR=0
DATE=`date +%Y%m%d-%H%M%S`
WRK_DIR="/usr/lnk/wrk/pde"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdecl2011.sh [-s] [-r] [-b <batch-range>] [-t] [-y <year>] [-x]
	<batch-range> is 16 characters	(required info)
	<year> is 4-digit year		(required info)

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


# Submit pdecl2011 program
submit_pdecl2011()
{
     runcobol ${OBJ_DIR}/pdecl2011 -s ${SKIP_SORT}${RESUB}${TEST_MODE}${SELECT_YEAR} -a ${SUB_YEAR}${BATCH_RANGE}  
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
    -r) RESUB=1
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
    -x) SELECT_YEAR=1
	;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

FG4AUD=/usr/lnk/audit/PDEAUD;export FG4AUD
PDECL00WRK=$PDECL00WRK-${DATE};export PDECL00WRK

if [ ${TEST_MODE} = 1 ]
then
	PDECL01KEY=$WRK_DIR/PDEKEY01TST;export PDECL01KEY
	FG4AUD=$WRK_DIR/PDEAUDTST;export FG4AUD
	PDECL00WRK=$WRK_DIR/PDECL00TST;export PDECL00WRK
fi

if [ $BATCH_RANGE = "null" -o $SUB_YEAR = "null" ]
then
	usage
fi


echo "PDE File Creation - pdecl2011"
date
submit_pdecl2011 
date

exit 0
