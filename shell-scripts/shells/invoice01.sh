#!/bin/ksh
#
# Program Name	: invoice01.sh
# Description   : Create Invoice From Invoice Log File. 
#                 Command line arguments:
#                 -c Claims Invoice
#                 -a Admin Invoice
#                 -t System Level <System# must be 4 digits>
#                 -s Sponsor Level <Sponsor# must be 8 digits>
#                 -g Group Level <Group# must be 16 digits>
#                 -p Period Ending
# Author	: James Masluk      
# Date		: 11/28/00
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
CLAIMS_INVOICE=0
ADMIN_INVOICE=0
SYSTEM_LEVEL=0
SPONSOR_LEVEL=0
GROUP_LEVEL=0
SYS=0000
SPO=00000000
GRP=0000000000000000 
PERIOD_ENDING=00000000

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: invoice01.sh [-c claims_invoice] [-a admin_invoice] [-t system #] [-s sponsor #] [-g group #] [-p period ending]

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

# Submit invoice01 program
submit_invoice01()
{
  runcobol ${OBJ_DIR}/invoice01 -s ${CLAIMS_INVOICE}${ADMIN_INVOICE}${SYSTEM_LEVEL}${SPONSOR_LEVEL}${GROUP_LEVEL} -a ${SYS}${SPO}${GRP}${PERIOD_ENDING}  

}
#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -c) CLAIMS_INVOICE=1
        ;;
    -a) ADMIN_INVOICE=1
        ;;
    -t) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SYSTEM_LEVEL=1
        SYS=$1
        ;;
    -s) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SPO=$1
        SPONSOR_LEVEL=1
        ;;
    -g) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        GROUP_LEVEL=1
        GRP=$1
        ;;
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        PERIOD_ENDING=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

echo "Invoice Files - INVOICE01"
date
submit_invoice01  
date

exit 0
