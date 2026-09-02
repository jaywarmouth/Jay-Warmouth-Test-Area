#!/bin/ksh
#
# Program Name  : crdfix01.sh
# Description   : FIX CARDHOLDER ENTERED WITH WRONG ID
#		  Command Line Arguments:
#                 -t Test Mode
#		  -f <filename> - File mode with input file
# Date          : 10/30/08
# Modifications : 02/01/2010 - Added procedures to copy output file to appropriate directories and systems so Warehouse can update.  (LSJ)
#		: 06/15/2011 - Changed file location and copy for warehouse
#		: 08/10/2015 - TT:12182-5 - New input file (IDCHGUPD01)
#		: 10/29/2015 - TT:12182-6 - Multiple changes/enhancements
#		: 5/6/2016 - TT4805-6 file location changes
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
TEST_MODE=0
FILE_MODE=0
WRK_DIR="/usr/upd/claims"
AUD_DIR="/usr/lnk/audit"
DATE=`date +%Y%m%d`
DATETM=`date +%Y%m%d%H%M%S`
USER=""
USERCLASS=""

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: crdfix01.sh [-t] -f <filename> -a [USERCLASS USER]

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


# Submit crdfix01 program
submit_crdfix01()
{
    runcobol ${OBJ_DIR}/crdfix01 -s ${TEST_MODE}${FILE_MODE} -a ${USERCLASS}${USER}'           ' 

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
    -a) shift
        if [ $# -le 0 ]
        then
           usage
        fi
        USERCLASS=$1
	USER=$2
        ;;
    -f) shift
	if [ $# -le 0 ]
        then
           usage
        fi
	FILE_MODE=1
	FILE=$1
	;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $FILE_MODE = 1 ]
then
	IDCHGUPD01=${FILE}
	REVOUTFILE=${WRK_DIR}/CRDFIX01-REVOUTFILE-${DATETM}.txt
	LIMIT30=${WRK_DIR}/CRDFIX01-LIMIT30-${DATETM}.txt
	LIMITCMS01=${WRK_DIR}/CRDFIX01-LIMITCMS01-${DATETM}.txt
	RSERR00PCX=${WRK_DIR}/CRDFIX01-RSERR00PCX-${DATETM}.csv
	export IDCHGUPD01 REVOUTFILE LIMIT30 LIMITCMS01 RSERR00PCX
fi

AUDIT20MAS=${AUD_DIR}/CLAIM02
export AUDIT20MAS 
PRINTERR=${WRK_DIR}/CRDFIX01-ERR-REPORT-${DATETM}.txt
PRINTWH=${SQLIMPORTS}/claims/CLM-FIX-REPORT-${DATE}
export PRINTWH PRINTERR


echo "FIX CARDHOLDER ENTERED WITH WRONG ID"
date
submit_crdfix01
date


exit 0
