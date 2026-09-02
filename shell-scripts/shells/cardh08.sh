#!/bin/ksh
#
# Program Name	: cardh08.sh
# Description   : Embossed Cards Report 
#                 Command line arguments:
#                 -c Type of run (pay or twice)
# Author	: Linda S. Jefferis
# Date		: 06/06/96
# Modifications : 04/23/97 Added env_var & OBJ_DIR logic  (LSJ)
#                 04/23/97 Removed proc_audit  (LSJ)
#                 01/20/05 - Added pay & twice-month cycle (DW)
#		: 09/26/2014 - Added "tweek" logic  (LSJ) Ticket #11688
#		: 02/09/2016 - TT13915-19 "week" logic
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
CYCLE="null"
PAY=0
TWICE=0
TWEEK=0
WEEK=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh08.sh [-c pay|twice|tweek|week]

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
        TWEEK=1
        ;;
    *)  usage
         ;;
   esac
}
# Submit cardh08 program
submit_cardh08()
{
        runcobol ${OBJ_DIR}/cardh08 -s ${PAY}${TWICE}${TWEEK}${WEEK} 
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
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
EMBOS00MAS=/usr/upd/crd_01/EMBOS00MAS.cd07
export EMBOS00MAS

CARDH07KEY=${CARDH07KEY}.cm${CYCLE}

echo Embossed Cards Report
echo "   CARDH07KEY=${CARDH07KEY}"
date
submit_cardh08                   
date

exit 0
