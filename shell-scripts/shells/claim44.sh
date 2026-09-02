#!/bin/ksh
#
# Program Name  : claim44.sh
# Description   : Pharmacy Remittance Reprint
#                 Command line arguments:
#                 -j Type of cycle (pay|twice|week) for all inclusive pay-cycle or twice-month cycle run
#                 -p - run with the period ending check
#			(for paid dates of 99999999)
#                 -c <filename> - run for chain reading a CLWRK file
#                 -f Assign alternate CLAIM00MAS
# Author        : Kim Konyshak      
# Date          : 06/21/96
# Modifications : 02/25/97 - Added logic for alternate CLAIM00MAS - LSJ
#                 04/16/97 - Remove proc_audit - KK
#                 06/23/97 - Added clm_01 to RUNPATH - LSJ
#                 07/16/97 - Change Print-3 to po/misc/CL44- KK
#                 07/16/97 - Added -c option to run a chain - LSJ
#                 02/15/00 - Added -p option to run by period ending - KK
#		  03/18/04 - Added -j(pay-cycle run) option  (LSJ)
#               : 12/07/04 - Changes for newcycle runs  (DW)
#		: 05/04/2005 - Changes for new week-cycle (LSJ)
#		: 02/24/2006 - Added umask command temporarily  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE_FLAG=0
CHAIN_FLAG=0
PERIOD_END=0
CYCLE_RUN=0
PAY=0
TWICE=0
WEEK=0
FXCOMMENT=" "


#
# Usage routine
usage()
{  cat << ENDOFUSAGE
usage: claim44.sh [-j pay|twice|week] [-p] [-f <filename>] [-c <filename>]
	-j  flag for all inclusive pay, twice, or week run   (optional)
		Mutually exclusive of all other options
	-p  flag for individual NABP run for period ending   (optional)
		looks for all 9's in paid date for NABP
	-c <filename>  use of CLWRK filename for chain run   (optional)
			do not run with -f option
	-f <filename>  using alternative CLAIM00MAS input file
			do not run with -c option

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
# Validate -j options
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
    *)  usage
         ;;
   esac
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -j) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CYCLE=$1
        CYCLE_RUN=1
        validate_cycle
        ;;
    -p) PERIOD_END=1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE=$1
        FILE_FLAG=1
        ;;
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLWRK=$1
        CHAIN_FLAG=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

umask 000

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

REPLY="0"
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
if [ ${CHAIN_FLAG} = 1 ]
then
   CLWRK00MAS=${CLWRK}
   export CLWRK00MAS
fi

runcobol ${OBJ_DIR}/claim44 -s ${CHAIN_FLAG}${PERIOD_END}${PAY}${TWICE}${WEEK}

date

if [ ${CYCLE_RUN} = 0 ]
then
   echo "\nEnter selection : 1. Print the report"
   echo "                  2. Fax the report"
   echo "                  3. Exit"
   while test $REPLY -ne 3
   do
     read REPLY
     case $REPLY in
       "1")  lp /usr/lnk/misc/CL44
             exit 0;
             ;;
       "2") echo "\nWho are you sending this to :"
            read FAXTO
            echo "\nWhat is their fax number    :"
            read FXNUM
            echo "\nEnter any comment to include    :"
            read FXCOMMENT
	    fax "$FAXTO" /usr/lnk/misc/CL44 $FXNUM port "$FXCOMMENT"
            #fax \"$FAXTO\" /usr/lnk/misc/CL44 $FXNUM 132
            exit 0;
            ;;
       "3") exit 0                 
            ;;
       "*") echo "Invalid choice\n"
            ;;
     esac
   done
fi

exit 0
