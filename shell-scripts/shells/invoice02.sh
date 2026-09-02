#!/bin/ksh
#
# Program Name	: invoice02.sh
# Description   : Claim Invoice Detail     
#                 Command line arguments:
#                 -s Skip sort flag
#                 -x Sponsor Number (8 digits)
#                 -c Type of cycle (pay, off)
#                 -b <batch range> (optional)
#			If not used, program uses the current pay beg/end dates
#                 -f Assign alternate CLAIM00MAS
# Author	: James Masluk
# Date		: 07/09/02
# Modifications : 01/24/2006 - Added "-f" option and lofic for assigning alternate name for INVOICE2KEY  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
SKIP_SORT=0
SPO=0
BATCH_INFO="                "
PAY=0
OFF=0
CYCLE="null"
FILE_FLAG=0
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: invoice02.sh [-s] [-x <sponsor>] [-b <batch range>] [-c pay|off] [-f <filename>]
        -s skip sort flag   (optional)
        -x sponsor number (######## - 8 digits)  (required)
        -b <batchrange>  <16-char>batchrange   (optional)
	-f <filename>				(optional)

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
     "pay")
        PAY=1
        ;;
     "off")
        OFF=1
        ;;
    *)  usage
         ;;

   esac
}

# Submit invoice02 program
submit_invoice02()
{
    runcobol ${OBJ_DIR}/invoice02 -s ${SKIP_SORT}${PAY}${OFF} -a ${SPO}${BATCH_INFO}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

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
    -x) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SPO=$1
        ;;
    -b) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        BATCH_INFO=$1
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
if  [ $PAY = 1 ]
then
   INVOICE2KEY=${INVOICE2KEY}-P;export INVOICE2KEY
fi
if  [ $OFF = 1 ]
then
   INVOICE2KEY=${INVOICE2KEY}-O;export INVOICE2KEY
fi

if [ ${FILE_FLAG} = 1 ]
then
   CLAIM00MAS=${FILE}
   export CLAIM00MAS
fi

echo "Marketing Fee Claims Invoice Detail"
date
submit_invoice02 
date

exit 0
