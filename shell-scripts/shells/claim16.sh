#!/bin/ksh
#
# Program Name	: claim16.sh
# Description   : Invoices 
#                 Command line arguments:
#                 -c Type of cycle (pay|twice|week|tweek)
#                 -i Type of invoice (sys,spo,grp)
#                 -s Skip sort flag
#                 -f Assign alternate CLAIM00MAS
#		  -r <rerun info>
#			16 Char. Batch Range
#			8 digit period end date <yyyymmdd>
# Author	: Linda S. Jefferis
# Date		: 04/12/96
# Modifications : 04/24/96 - Added logic for command line arguments
#               : 02/12/97 - Removed proc_audit logic - LSJ
#                 03/12/97 - Added -f option - LSJ
#                 03/12/97 - Added env_var & OBJ_DIR logic - LSJ
#                 04/02/97 - Removed OPREP00MAS - LSJ
#                 11/29/04 - Added Type of cycle (pay or twice-month) (DW)
#                 04/22/05 - Added (week) cycle (DW)
#		  02/20/2006 - Added new assignments of SUSPWRKMAS for each cycle  (LSJ)
#		  12/14/2009 - Added logic for new mweek option (MEDD week)
#		  01/08/2010 - Changed MEDD logic for using "-m" option instead of "mweek" cycle type
#		  10/03/2010 - Added logic for new TWEEK cycle  (LSJ)
#		  12/29/2015 - TT8641-32; PARMFILE and new INVTOT files (LSJ)
#		  01/31/2018 - TT2119-215; changes to runcobol and added TRACE
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
INV="null"
CYCLE="null"
SKIP_SORT=0
FILE_FLAG=0
PAY=0
TWICE=0
WEEK=0
TWEEK=0
SYS=0
SPO=0
GRP=0
TRACE_FLAG="N"
# if TRACE=”Y” all of the print filenames will display, as well as a record-count progress display (in increments of 20,0000)
RERUN=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim16.sh [-c pay|twice|week|tweek] [-i sys|spo|grp] [-s] [-f <filename>]

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

#
# Validate -c options
validate_cycle()
{  case ${CYCLE} in
     "pay")
        PAY=1
        ;;
     "twice")
        TWICE=1
        ;;
     "week")
        WEEK=1
        ;;
     "tweek")
        TWEEK=1
        ;;
    *)  usage
         ;;
   esac
}

# Validate -i options
validate_inv()
{  case ${INV} in
     "sys")
	SYS=1
	;;
     "spo")
	SPO=1
	;;
     "grp")
	GRP=1
	;;
     *)  usage
	 ;;
   esac
}

# Submit claim16 program
submit_claim16()
{
   if [ ${INV} = "null" ]
   then
     usage
   fi
   if [ ${RERUN} = 1 ]
   then
	runcobol ${OBJ_DIR}/claim16 -a ${SKIP_SORT}${SYS}${SPO}${GRP}${PAY}${TWICE}${WEEK}${TWEEK}${TRACE_FLAG}${RERUNINFO}
   else
     runcobol ${OBJ_DIR}/claim16 -a ${SKIP_SORT}${SYS}${SPO}${GRP}${PAY}${TWICE}${WEEK}${TWEEK}${TRACE_FLAG}
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
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CYCLE=$1
        validate_cycle
        ;;
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        INV=$1
        validate_inv
        ;;
    -s) SKIP_SORT=1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	RERUN=1
        RERUNINFO=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $PAY = 1 ]
then
   INLGWRKMAS=$INLGWRKMAS-P;export INLGWRKMAS
   SUSPWRKMAS=$SUSPWRKMAS-P;export SUSPWRKMAS
   CLAIM16KEY=$CLAIM16KEY-P;export CLAIM16KEY
fi
if [ $TWICE = 1 ]
then
   INLGWRKMAS=$INLGWRKMAS-T;export INLGWRKMAS
   SUSPWRKMAS=$SUSPWRKMAS-T;export SUSPWRKMAS
   CLAIM16KEY=$CLAIM16KEY-T;export CLAIM16KEY
fi
if [ $WEEK = 1 ]
then
   INLGWRKMAS=$INLGWRKMAS-W;export INLGWRKMAS
   SUSPWRKMAS=$SUSPWRKMAS-W;export SUSPWRKMAS
   CLAIM16KEY=$CLAIM16KEY-W;export CLAIM16KEY
fi
if [ $TWEEK = 1 ]
then
   INLGWRKMAS=$INLGWRKMAS-X;export INLGWRKMAS
   SUSPWRKMAS=$SUSPWRKMAS-X;export SUSPWRKMAS
   CLAIM16KEY=$CLAIM16KEY-X;export CLAIM16KEY
fi


if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

PARMFILE=/usr/lnk/log/PARMFILE-CLAIM16.txt; export PARMFILE
MSTRGROUP00MAS=$GROUP00MAS; export MSTRGROUP00MAS

echo Invoices
date
echo
echo "CLAIM00MAS=$CLAIM00MAS"
echo "INLGWRKMAS=$INLGWRKMAS"
echo "SUSPWRKMAS=$SUSPWRKMAS"
echo "CLAIM16KEY=$CLAIM16KEY"
echo "SYSTE00MAS=$SYSTE00MAS"
echo "PARMFILE=$PARMFILE"

# Submit the program
submit_claim16 

date

exit 0
