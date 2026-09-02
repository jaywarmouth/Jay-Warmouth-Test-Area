#!/bin/ksh
#
# Program Name	: claim70.sh
# Description   : Post Marketing Fee 
#                 Command line arguments:
#                 -o Mkt fee vs Ntwrk rental fee option (mkt,net)
#                 -s Skip sort flag
#                 -f Assign alternate CLAIM00MAS
# Author	: Linda S. Jefferis
# Date		: 04/12/96
# Modifications : 04/24/96 - Added logic for command line arguments
#                 02/28/97 - Added -f arugment - LSJ
#                 02/28/97 - Added env_var and OBJ_DIR logic and removed proc_audit - LSJ
#                 01/09/04 - Added Mkt fee vs Network Rental fee pass selection - DW
#                 04/05/05 - Added (week) cycle (DW)
#		: 09/18/2009 - Changes for switch to new check run process
#		: 5/18/2018 - TT18167-66; code changes.
#
# Variables Used:
OBJ_DIR="/usr/lnk/obj"
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PASS_OPTION="null"
SKIP_SORT=N
FILE_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim70.sh [-o mkt|net] [-s] [-f <filename>]
        -s              Skip Sort Flag                  optional
        -o <mkt|net>    Market/Network Fee              required
        -f <filename>   Alternate input Claims file     optional


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
# Validate -o options
validate_option()
{  case ${PASS_OPTION} in
     "mkt")
	PASS=N
	;;
     "net")
	PASS=Y
        ;;
     *)  usage
         ;;
   esac
}

# Submit claim70 program
submit_claim70()
{
   if [ ${PASS_OPTION} = "null" ]
   then
     usage
   else
     runcobol ${OBJ_DIR}/claim70 -a ${SKIP_SORT}NN${PASS}NN 
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
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        PASS_OPTION=$1
        validate_option
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
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

INLGWRKMAS=$INLGWRKMAS-C;export INLGWRKMAS
CLAIM70KEY=${CLAIM70KEY}-${PASS_OPTION};export CLAIM70KEY

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

echo "Post Marketing Fees - claim70"
date
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   INLGWRKMAS=$INLGWRKMAS"
echo "   CLAIM70KEY=$CLAIM70KEY"
submit_claim70 
date

exit 0
