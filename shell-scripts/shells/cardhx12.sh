#!/bin/ksh
#
# Program Name  : cardhx12.sh
# Description   : 834 X12 FILE CONVERSION
#		  Command Line Arguments:
#                 -t Test Mode (Demo)
#                 -f File Name
# Author        : Jim Masluk
# Date          : 03/22/04
# Modifications : 05/05/05 Add Test Mode Switch
#		: 12/28/2021 - adjusted CARDH00TMP variabe name.
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE_NAME="null"
TEST_MODE=0
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardhx12.sh [-t] [-f <file name>] 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file...                                                 "

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


# Submit cardhx12 program
submit_cardhx12()
{
    echo ${DATE}
    runcobol ${OBJ_DIR}/cardhx12 -s ${TEST_MODE} -a ${FILE_NAME}${FOLDER_NAME}       
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
    -t) TEST_MODE=1
        ;;
    -f) shift
        FILE_NAME=$1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
CID=`echo ${FILE_NAME} | cut -c1-2`
CARDH00TMP=${HOME}/CARDH00TMP-${CID}
export CARDH00TMP
#
#================================================
#ENTER FOLDER NAME
#================================================
#
FOLDER_NAME=/usr/lnk/elig_in/
#


echo "834 X12 File Conversion"
date
echo ""
submit_cardhx12
rm -f $CARDH00TMP
date

exit ${RETVAL}
