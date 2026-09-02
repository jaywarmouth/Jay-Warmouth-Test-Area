#!/bin/ksh
#
# Program Name  : cardh53.sh
# Description   : Purge CARDH00MAS of Systems = T-LINK                  
#                 Command line arguments:
#                 -l Set System link (must be 5 chars.)
# Author        : Deborah Wilson            
# Date          : 03/14/01
# Modifications : 04/13/2001 - Added paging  (LSJ)                
#		: 10/20/2005 - Changes for Linux commands  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
LINK="null"              
PAGE_PROG="/usr/local/bin/pageuser.sh"
REMOTE="raven-e1"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh53.sh [-l "<link>"]                         

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

# Submit cardh53 program
submit_cardh53()
{
        echo ${DATE}
        runcobol ${OBJ_DIR}/cardh53 -a ${LINK}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -l) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        LINK=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
CAWRK00MAS=/usr/lnk/sort/CAWRK00MAS.HSC
CAWRK00NEW=/usr/lnk/crd_02/CAWRK00NEW
export CAWRK00MAS CAWRK00NEW

date

echo
echo "EXPORT PATHS:"
echo "   CARDH00MAS=${CARDH00MAS}"
echo "   CAWRK00MAS=${CAWRK00MAS}"
echo "   CAWRK00NEW=${CAWRK00NEW}"

echo "--> Copying CARDH00MAS"
rm -f ${CARDH00MAS}
scp ${REMOTE}:${CARDH00MAS} ${CARDH00MAS}

${PAGE_PROG} "cardh53" "starting" linda

submit_cardh53

${PAGE_PROG} "cardh53" "completed" linda

date

exit 0
