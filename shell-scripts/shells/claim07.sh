#!/bin/ksh
#
# Program Name	: claim07.sh
# Description   : Check Register 
#                 Command line arguments:
#                 -s Skip sort flag
#                 -r Rerun flag
#                 -n Negative check flag
#                 -f Assign alternate CLAIM00MAS
# Author	: Linda S. Jefferis
# Date		: 04/12/96
# Modifications : 04/24/96 - Added logic for command line arguments
#                 05/10/96 - Added -f option
#                 02/28/97 - env_var, OBJ logic and removed proc_audit - LSJ
#		: 11/14/00 - Changed name of CHECK00WRK.cycle  (LSJ)
#		: 08/10/2001 - Changed path for CHECK00WRK  (LSJ)
#		: 05/02/2005 - Changes for new week-cycle  (LSJ)
#		: 03/07/2006 - Changes for new check-fix switch  (MP)
#		: 09/18/2009 - Changes for switch to new check run process
#		: 10/20/2014 - Changes for check outsourcing file creation (KEYPHARM and KEYDMR)  (LSJ) TT #6939-2
#		: 10/27/2014 - Removed "-q" option logic  (LSJ)
#		: 08/28/2018 - TT18167-34; runcobol command change
#		: 08/30/2018 - revert changes back.
#		: 09/26/2018 - TT18579-5
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
RERUN=0
NEG_CHK=0
FILE_FLAG=0
CHK_FIX=0
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim07.sh [-s] [-r] [-n] [-f <filename>] 

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


# Submit claim07 program
submit_claim07()
{
    runcobol ${OBJ_DIR}/claim07 -a ${SKIP_SORT}000${RERUN}${NEG_CHK}0${CHK_FIX}

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
    -r) RERUN=1
        ;;
    -n) NEG_CHK=1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_FLAG=1
        FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

# Stops change updates for RXODS
CHGFILEFLAG=N; export CHGFILEFLAG

cp /usr/upd/claims/CHECK00WRK.null /usr/upd/claims/CHKWRK-C
CHECK00MAS=/usr/upd/claims/CHKWRK-C;export CHECK00MAS
INLGWRKMAS=${INLGWRKMAS}-C;export INLGWRKMAS
KEYPHARM=/usr/lnk/tapes/KEYPHARM-${DATE}.arm.kbarm; export KEYPHARM
KEYDMR=/usr/lnk/tapes/KEYDMR-${DATE}.arm.kbarm; export KEYDMR
KEYCARDERR=/usr/lnk/misc/KEYCARDERR-C.txt; export KEYCARDERR

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

echo "Check Register"
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CHECK00MAS=$CHECK00MAS"
echo "   INLGWRKMAS=$INLGWRKMAS"
echo "   KEYPHARM=$KEYPHARM"
echo "   KEYDMR=$KEYDMR"
echo "	 KEYCARDERR=$KEYCARDERR"
submit_claim07 
date

exit 0
