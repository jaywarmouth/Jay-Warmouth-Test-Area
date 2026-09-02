#!/bin/ksh
#
# Program Name	: rever02_newcycle.sh
# Description   : Select Reversals 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -c Type of Cycle (twice|tweek)
#                 -d Set alternate start date <ccyymmdd>
#		  -r Rerun report dated <ccyymmdd>
# Author	: Debbie Wilson    
# Date		: 05/29/98
#               : 07/02/98 (LSJ)  Added logic for '-r' option.
#		  11/25/98 (LSJ)  Added assignment of AUDIT20MAS
#		  12/11/98 (LSJ)  Changed AUDIT20MAS to FG4AUD (=REVAUD)
#		  05/27/99 (LSJ)  Changed input dates to 8-digits (century)
#		  04/08/2005  (LSJ) newcycle changes
#		: 04/17/2007 (LSJ) Fixed /usr/lnk/wrk/REVAUD to /usr/lnk/audit/REVAUD
#               : 09/21/2010 (MJP) added tweek cycle
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
START_FLAG=0
RERUN_FLAG=0
RERUN_DATE="00000000"
START_DATE="00000000"
TWICE=0
TWEEK=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rever02.sh [-s] [-c twice|tweek] [-d <ccyymmdd>] [-r <ccyymmdd>]

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

# Validate -c options
validate_cycle()
{  case ${CYCLE} in
     "twice")
        TWICE=1
        ;;
     "tweek")
        TWEEK=1
        ;;
    *)  usage
         ;;
   esac
}


# Submit rever02 program
submit_rever02()
{
   runcobol ${OBJ_DIR}/rever02 -s ${SKIP_SORT}${TWICE}${TWEEK}${START_FLAG}${RERUN_FLAG}  -a ${START_DATE}${RERUN_DATE}
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
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CYCLE=$1
        validate_cycle
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        START_FLAG=1
        START_DATE=$1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN_FLAG=1
        RERUN_DATE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
FG4AUD=/usr/lnk/audit/REVAUD
export FG4AUD


echo "Old Reversal Report"
date
submit_rever02 
date

exit 0
