#!/bin/sh
#
# Program Name	: cardh07.sh
# Description   : Embossed Cards Invoices 
#                 Command line arguments:
#                 -c Type of run (pay or twice)
#                 -s Skip sort flag
# Author	: Linda S. Jefferis
# Date		: 06/06/96
# Modifications : 04/23/97 Added env_var & OBJ_DIR logic  (LSJ)
#                 04/23/97 Removed proc_audit  (LSJ)
#                 01/19/05 - Added pay & twice-month cycle (DW)
#		: 11/02/2007 - Added logic for INLGWRKMAS  (LSJ)
#		: 09/26/2014 - Add "tweek" logic  (LSJ) Ticket #11688
#		: 10/05/2014 - Fix tweek logic
#		: 02/09/2016 - TT13915-19 "week" logic/
#		: 06/30/2022 - Changes to run on Prod10 and read EMBOS00MAS instead of copied EMBOS00MAS.cd07
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
SKIP_SORT=0
CYCLE="null"
PAY=0
TWICE=0
TWEEK=0
WEEK=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh07.sh [-c pay|twice|tweek|week] [-s] 

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
     "tweek")
        TWEEK=1
        ;;
     "week")
        WEEK=1
        ;;
    *)  usage
         ;;
   esac
}

# Submit cardh07 program
submit_cardh07()
{
        runcobol ${OBJ_DIR}/cardh07 -s ${SKIP_SORT}${PAY}${TWICE}${TWEEK}${WEEK}
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
    -s) SKIP_SORT=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
#EMBOS00MAS=/usr/upd/crd_01/EMBOS00MAS.cd07
#export EMBOS00MAS

CARDH07KEY=${CARDH07KEY}.cm${CYCLE}

if [ $PAY = 1 ]
then
   INLGWRKMAS=$INLGWRKMAS-CRDS-P;export INLGWRKMAS
fi
if [ $TWICE = 1 ]
then
   INLGWRKMAS=$INLGWRKMAS-CRDS-T;export INLGWRKMAS
fi
if [ $TWEEK = 1 ]
then
   INLGWRKMAS=$INLGWRKMAS-CRDS-X;export INLGWRKMAS
fi
if [ $WEEK = 1 ]
then
   INLGWRKMAS=$INLGWRKMAS-CRDS-W;export INLGWRKMAS
fi

echo "Embossed Cards Invoices"
echo "   CARDH07KEY=${CARDH07KEY}"
date
submit_cardh07 
date

exit 0
