#!/bin/ksh
#
# Program Name  : cardh78.sh
# Description   : Load CARDH00MAS and LIMIT00MAS changes for TrialCard.
#		  Command Line Arguments:
#                  -t Test Mode
#		   -f Full file flag
#		   -r <date range> - e.g. ccyymmddccyymmdd
# Author        : James Masluk
# Date          : 05/28/2009
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FULL_FILE=0
TEST_MODE=0
RERUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh78.sh [-f] [-t]
	-f full file flag	(optional)
	-t test mode		(optional)
	-r <date range>		(optional)
		where <date range> is ccyymmddccyymmdd

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


# Submit cardh78 program
submit_cardh78()
{
	if [ $RERUN = 1 ]
	then
		echo "DATE RANGE: ${DATE_RANGE}"
		runcobol ${OBJ_DIR}/cardh78 -s ${FULL_FILE}${RERUN}${TEST_MODE} -a ${DATE_RANGE}
	else
        	runcobol ${OBJ_DIR}/cardh78 -s ${FULL_FILE}${RERUN}${TEST_MODE}
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
    -f) FULL_FILE=1
        ;;
    -t) TEST_MODE=1
	;;
    -r) RERUN=1
	shift
        if [ $# -le 0 ]
        then
          usage
        fi
	DATE_RANGE=$1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables


echo "Load CARDH00MAS and LIMIT00MAS Files"
date
submit_cardh78
date

exit 0
