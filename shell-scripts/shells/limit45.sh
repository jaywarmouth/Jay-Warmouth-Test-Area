#!/bin/ksh
#
# Program Name  : limit45.sh
# Description   : Update Last Quarter Carryover Amoumt
#                 Command line arguments:
#                 -d date of file (mmdd)
# Author        : James Masluk     
# Date          : 12/29/2004
# Modification  : 01/25/2005 - Added assigning of files and changed "l" to "d"  (LSJ)
#		: 07/20/2005 - Addition of "umask 002" command  (LSJ)
#		: 10/19/2006 - Changes for 4-digit system number  (LSJ)
#               : 06/03/2013 - Removed zip_arch_elig.sh procedure (DME)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj 
ELIG_DIR="/usr/lnk/elig_in"
ELIG_OUT="/usr/lnk/elig_in_1"
AUDIT_DIR="/usr/lnk/audit"
DATE="null"
SYS=0035
CLIENT="su"
SHELL="/usr/lnk/shell"
TEST_MODE=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: limit45.sh  -d <mmdd>

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
# Print report
print_rpt()
{
        if test -s ${PRT_DIR}/LIMIT45
        then
                lp ${PRT_DIR}/LIMIT45
        fi
}

#
# Cleanup
cleanup()
{
	rm -f ${ELIG_DIR}/${CLIENT}d${DATE}
	mv ${ELIG_OUT}/${CLIENT}d${DATE} ${ELIG_OUT}/sys${SYS}
}

# Submit limit45 program
submit_limit45()
{
     runcobol ${OBJ_DIR}/limit45 -s ${TEST_MODE} -a ${DATE} 

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
    -t) TEST_MODE=1
        ;;
    -d) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	DATE=$1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

umask 000

# Assign alternate environment variables

LIMIT45TAP=${ELIG_DIR}/${CLIENT}d${DATE}
export LIMIT45TAP

AUDIT20MAS=${AUDIT_DIR}/LIMAUD
export AUDIT20MAS

if [ ${TEST_MODE} = 1 ]
then
  PRT_DIR="/usr/lnk/wrk"
else
  PRT_DIR="/usr/lnk/misc"
fi


echo "SYSTEM - ${SYS}"
echo ""
echo "Update Last Quarter Carryover Amount"
date
submit_limit45
date

# Print procedure
echo ""
echo "--> Printing Report..."
print_rpt

# Cleanup
echo ""
echo "--> Doing Cleanup..."
cleanup

exit 0
