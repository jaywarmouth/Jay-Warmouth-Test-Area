#!/bin/ksh
#
# Program Name	: cardroll80.sh
# Description   : Update System 80 Cardholder rollover dates
#                 Command line arguments:
#                 -s Skip Sort
#                 -t Test Mode
# Author	: Michael Paulus
# Date		: 10/17/05
# Modifications : 12/29/06  Add skip sort switch.
#		: 06/07/2018 - Add RETVAL logic.
#		: 07/25/2018 - changing cobol switch from a "-s" to a "-a" (TT:18265-3; DME)
#		: 07/31/2018 - adding coding to export the new PARM file. (TT:#18265-3; DME)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
SKIP_SORT=0
AUDIT_DIR="/usr/lnk/audit"
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardroll80.sh [-t test_mode][-s skip_sort]

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

# Submit cardroll80 program
submit_cardroll80()
{
   runcobol ${OBJ_DIR}/cardroll80 -a ${TEST_MODE}${SKIP_SORT}   
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
    -t) TEST_MODE=1
        ;;
    -s) SKIP_SORT=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

FG4AUD=${AUDIT_DIR}/CRDAUD
export FG4AUD

if [ ${TEST_MODE} = 1 ]
then
   FG4AUD=/usr/lnk/wrk/FG4AUD  
     export FG4AUD       

fi

umask 111

CARDROLL80PRM=/usr/lnk/log/CARDROLL80PRM.txt  
export CARDROLL80PRM

echo "Update system 80 cardholder roll dates"    
date
submit_cardroll80
date

echo "RETURN-CODE=$RETVAL"
echo ""

exit $RETVAL

