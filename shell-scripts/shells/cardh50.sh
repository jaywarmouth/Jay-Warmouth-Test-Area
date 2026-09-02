#!/bin/ksh
#
# Program Name  : cardh50.sh
#                 Command Line Arguments:
#                 -i <filename> - input file name
#                 -f <filename> - output file name
# Description   : HEALTHREACH/ARGUS FILE CONVERSION
# Author        : David Tucci
# Date          : 12/15/97
# Modifications : 02/05/98 - Added -f option  (LSJ)
#                 02/10/98 - Added -i option  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
USER=""
OUTPUT_FILE="null"
INPUT_FILE="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh50.sh [-f <filename>] [-i <filename>]

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


# Submit cardh50 program
submit_cardh50()
{
        runcobol ${OBJ_DIR}/cardh50

}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
   case "$1"
   in
      -i) shift
          if [ $# -le 0 ]
          then
             usage
          fi
          INPUT_FILE=$1
          ;;
      -f) shift
          if [ $# -le 0 ]
          then
             usage
          fi
          OUTPUT_FILE=$1
          ;;
   esac
   shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INPUT_FILE} = "null" -o ${OUTPUT_FILE} = "null" ]
then
   usage
else
   ARGUS00TAP=${INPUT_FILE}
   CARDH29TAP=${OUTPUT_FILE}
   export CARDH29TAP ARGUS00TAP
fi

echo Eligibility Conversion - Healthreach
date
submit_cardh50
date

exit 0
