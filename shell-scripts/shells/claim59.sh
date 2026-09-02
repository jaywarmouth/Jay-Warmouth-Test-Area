#!/bin/ksh
#
# Program Name	: claim59.sh
# Description   : Set Period Ending Dates 
#                 Command line arguments:
#                 -t TA end of month cycle                       
#                 -p Process-one-claim flag
#                 -r Set date for re-run, <ccyymmdd>

# Author	: Linda S. Jefferis
# Date		: 04/12/96
# Modifications : 04/24/96 - Added logic for command line arguments
#
#                 01/23/97 - CMS - TOOK OUT EXPORT OF COPAY00MAS=/usr/pdm/claims/COPAY00NEW
#                 03/14/97 - Added env_var & OBJ_DIR logic - LSJ
#		  11/12/99 - Added print of PRINT-CLAIM59 report  (LSJ)
#                 06/08/04 - Added CMS-TA Switch for closing out end of physical month (DW)
#                 11/05/04 - Deleted Week switch, added re-run switch with date sent in (DW)
#		: 10/24/2005 - Changes for Linux  (LSJ)
#		: 10/31/2017 - TT:3200-169; RETVAL logic.
#		: 12/19/2018 - TT18987-70; CYCLERRS logic
#		: 06/04/2019 - Remove CYCLERR assignements

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
ONE_CLAIM=0
TA=0
DATE=0
RERUN=0
RETVAL=0
PRINT_CLAIM59="/usr/lnk/misc/PRINT-CLAIM59"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
DATETM=`date +%Y%m%d_%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim59.sh [-t] [-p] [-r <ccyymmdd>]

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


# Submit claim59 program
submit_claim59()
{
   if [ ${RERUN} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim59 -s ${ONE_CLAIM}${TA}1 -a "${DATE}"
     else
        runcobol ${OBJ_DIR}/claim59 -s ${ONE_CLAIM}${TA}0 
   fi
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
    -t) TA=1 
        ;;
    -p) ONE_CLAIM=1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1  
        RERUN=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

umask 002

# Assign alternate variables

echo "Set Period Ending Dates - claim59"
echo "HOSTNAME=${HOSTNAME}"
date
submit_claim59 
date

echo "RETVAL/RETURN-CODE = $RETVAL"

exit $RETVAL
