#!/bin/ksh
#
# Program Name  : elgrt03.sh
# Description   : Eligibility Program
#
# Author        : Swapnil Gupta
# Date          : 09/23/25
# Modifications : 
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
ZEROES="0000"
TEST_MODE=0
BACKUP=0
INT_FOLDER=/usr/lnk/audit/rte
DATE=$(date +%Y%m%d)
COUNTER_FILE=/usr/lnk/audit/rte/"counter_${DATE}.txt"
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: elgrt03.sh [-t] [-l <line number>]

ENDOFUSAGE
  exit 1
}
#
#
#
counter_file_process()
{
if [ ! -f "$COUNTER_FILE" ]; then
    VAR="00000001"  # Fixed: Start with 1, not 0
else
    # File exists, read current content
    CUR_VALUE=$(cat "$COUNTER_FILE" 2>/dev/null)
    
    # Remove whitespace/newlines
    CUR_VALUE=$(echo "$CUR_VALUE" | tr -d '[:space:]')
    
    # Validate that content is numeric - Fixed variable name
    if [[ "$CUR_VALUE" =~ ^[0-9]+$ ]] && [ ! -z "$CUR_VALUE" ]; then
        # Fixed variable name here too
        NEW_VALUE=$((10#$CUR_VALUE + 1))
        VAR=$(printf "%08d" $NEW_VALUE)
    else
        VAR="00000001"
    fi
fi

# Store the value in file
echo "$VAR" > "$COUNTER_FILE"
}
#
# Parse environment variables file
#
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
#
# Submit elgrt03 program
#
submit_elgrt03()
{
    /opt/rmcobol/runcobol ${OBJ_DIR}/elgrt03 -K 
}
#
# Main routine
#
# Check command line validity, call usage if incorrect
UUID=$1
SYS_NUMBER="${ZEROES}$2"
SYSTEM_NUMBER="${SYS_NUMBER:(-4)}"
CLIENT_ID="$3"

# Parse environment variables
parse_env
counter_file_process

# Assign alternate environment variables


echo "Trial Card Automated Eligibility Program"
ELGRT02TAP=${INT_FOLDER}/ELGRT03-${UUID}
#ELGRT02TAP=/media/test/elgrt03/testfile
export ELGRT02TAP

BACKUPFILE=${INT_FOLDER}/BACK-UP-FILE-${UUID}
export BACKUPFILE

ERROR00PCX=${INT_FOLDER}/ERROR00PCX-${UUID}
export ERROR00PCX

PRINT=${INT_FOLDER}/PRINT-${UUID}
export PRINT

PRINTERR=${INT_FOLDER}/PRINT-ERR-${UUID}
export PRINTERR

RESPDAYFILE=${INT_FOLDER}/RESP-DAY-FILE-${UUID}
export RESPDAYFILE

RESPONSEFILE=${INT_FOLDER}/RESPONSE-FILE-${UUID}
export RESPONSEFILE

FG4AUD=${INT_FOLDER}/CRDAUD-RT-${UUID}
export FG4AUD

LIMRT01_FOLDER="/usr/lnk/elig_in/sys"${SYSTEM_NUMBER}"/"

ELGRT03_PARM="${ELGRT02TAP},${CLIENT_ID},${SYSTEM_NUMBER},${LIMRT01_FOLDER},${VAR},"
export ELGRT03_PARM

SUMMREPORT=${INT_FOLDER}/SUMM-REPORT-${UUID}
export SUMMREPORT

echo "Trial Card Automated Eligibility Program"
echo "ELGRT02TAP=   ${ELGRT02TAP}"
echo "BACKUPFILE=   ${BACKUPFILE}"
echo "ERROR00PCX=   ${ERROR00PCX}"
echo "PRINT=        ${PRINT}"
echo "PRINTERR=     ${PRINTERR}"
echo "RESPDAYFILE=  ${RESPDAYFILE}"
echo "RESPONSEFILE= ${RESPONSEFILE}"
echo "ELGRT03=      ${ELGRT03_PARM}"
echo "$CARDH00MAS"

date
submit_elgrt03 
date

cat ${FG4AUD} >> /usr/lnk/audit/CRDAUD-RT 

rm -f ${INT_FOLDER}/CRDAUD-RT-${UUID}

echo "==============================================================================================="

exit 0
