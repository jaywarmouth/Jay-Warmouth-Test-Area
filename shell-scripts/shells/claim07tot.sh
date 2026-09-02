#!/bin/ksh
#
# Program Name	: claim07tot.sh
# Description   : Check Register - system level totals for new check run
#                 Command line arguments:
#                 -s Skip sort flag
#                 -r Rerun flag
#                 -n Negative check flag
#                 -f Assign alternate CLAIM00MAS
#                 -q Check number fix <independant - 000 + nabp + no. of checks>
#                                     <chain       - 00000 + chain number + no. of checks>
#                                     <dmr         - cardholder number + no. of checks>
# Author	: Linda S. Jefferis
# Date		: 09/29/2009
# Modifications :
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
CHK_INFO="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim07tot.sh [-s] [-r] [-n] [-f <filename>] [-q <typeid><no.of checks>]

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


# Submit claim07tot program
submit_claim07tot()
{
     if [ ${CHK_FIX} = 1 ]
     then
	runcobol ${OBJ_DIR}/claim07tot -s ${SKIP_SORT}000${RERUN}${NEG_CHK}0${CHK_FIX} -a ${CHK_INFO}
     else
      	runcobol ${OBJ_DIR}/claim07tot -s ${SKIP_SORT}000${RERUN}${NEG_CHK}0${CHK_FIX}
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
    -q) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CHK_FIX=1
        CHK_INFO=$1  
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

CHECK00MAS=/usr/upd/claims/CHKWRK-C;export CHECK00MAS
INLGWRKMAS=${INLGWRKMAS}-C;export INLGWRKMAS

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

echo "Special System Level Check Totals"
date
echo "EXPORT PATHS:"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   CHECK00MAS=$CHECK00MAS"
echo "   INLGWRKMAS=$INLGWRKMAS"
echo "   CLM07TOTKEY=$CLM07TOTKEY"
submit_claim07tot 
date

exit 0
