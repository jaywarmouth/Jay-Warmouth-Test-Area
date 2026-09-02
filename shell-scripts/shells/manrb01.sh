#!/bin/ksh
#
# Program Name  : manrb01.sh
# Description   : Load MANRB00MAS File Using GENTB00MAS File.
#		  Command Line Arguments:
#                  -d Medicare D
#                  -t Test Mode
#                  -b Date Range - Quarter Beginning and ending dates <ccyymmddccyymmdd>
# Author        : James Masluk
# Date          : 06/26/2006
# Modifications : 11/21/2006 - Added logic for null files  (LSJ)
#		: 12/03/2007 - Added display of DATE_RANGE on rpt  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
MED_D=0
TEST_MODE=0
DATE_RANGE=0
NULL_MANRB="/usr/upd/drug/MANRB.null"
NULL_MANRB_MEDD="/usr/upd/drug/MANRB-MEDD.null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: manrb01.sh -d -t -b <date range>
	-d Medicare Part D flag				optional
	-t test run flag				optional
	-b <qrt. date range>  format yyyymmddyyyymmdd	required

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


# Submit manrb01 program
submit_manrb01()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/manrb01 -s ${MED_D}${TEST_MODE} -a ${DATE_RANGE}

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) MED_D=1
        ;;
    -t) TEST_MODE=1
	;;
    -b) shift
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

if [ ${MED_D} = 1 ]
then

	cp ${NULL_MANRB_MEDD} ${MANRB00MAS}-MEDD
	MANRB00MAS=${MANRB00MAS}-MEDD
	export MANRB00MAS
else
	cp ${NULL_MANRB} ${MANRB00MAS}
fi

echo "Load MANRB00MAS File Using GENTB00MAS File"
date
echo ""
echo "DATE RANGE = ${DATE_RANGE}"
echo ""
submit_manrb01
date

exit 0
