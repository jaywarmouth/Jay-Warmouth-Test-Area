#!/bin/ksh
#
# Program Name  : claim80rb.sh
# Description   : UPDATE CLAIM80MAS MASTER FILE TO REDBRICK
#                 Command Line Arguments:
#                 -b Batch Range <Enter a batch range. If no -b program will process previous day's batch>
#                 -o <filename> - alternate output file name (optional)
#		  -z Sample data Flag
# Author        : Jim Masluk
# Date          : 03/27/2001
# Modifications : 04/05/2001 - Changed the -o from a required argument to an optional one and put CLAIM80RB1 in env_var  (LSJ)
#		: 05/02/2001 - Added -z flag  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
BATCH_RANGE=0
ARGUMENT=""
OUTPUT_FILE="null"
FILE_FLAG=0
SAMP_FLAG=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim80rb.sh [-b <batch range>] [-o <filename>] [-z]

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


# Submit claim80rb program
submit_claim80rb()
{

   if [ ${BATCH_RANGE} = 1 ]
     then
        runcobol ${OBJ_DIR}/claim80rb -s 1 -a "${ARGUMENT}" 
     else
        runcobol ${OBJ_DIR}/claim80rb -s 0
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
      -b) shift
          if [ $# -le 0 ]
          then
            usage
          fi
          BATCH_RANGE=1
          ARGUMENT=$1
        ;;
      -o) shift
          if [ $# -le 0 ]
          then
             usage
          fi
	  FILE_FLAG=1
          OUTPUT_FILE=$1
          ;;
      -z) SAMP_FLAG=1
	  ;;
   esac
   shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${SAMP_FLAG} = 1 ]
then
        ENV_FILE="/usr/lnk/demo/env_var.demo"
        parse_env
fi
if [ ${FILE_FLAG} = 1 ]
then
   CLAIM80RB1=${OUTPUT_FILE}
   export CLAIM80RB1
fi

rm -f ${CLAIM80RB1}
echo "CLAIM80MAS FILE UPDATE"
echo ""
echo "EXPORT FILES:"
echo "   CLAIM80MAS=${CLAIM80MAS}"
echo "   CLAIM80RB1=${CLAIM80RB1}"
echo ""

date
submit_claim80rb  
date

exit 0
