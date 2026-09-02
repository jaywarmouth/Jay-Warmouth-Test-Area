#!/bin/ksh
#
# Program Name	: accum451.sh
# Description   : Batch accumulator update process for system 68 sponsor 451 Montana Health
#               : Program and shell based on limit29
#                 Command line arguments:
#                 -u Update LIMIT00MAS File when on
#                 -t Test Mode (skips update of audit files when on)
#                 -d date of file (mmdd)
# Author	: Peggy Voytilla
# Date		: 01/15/2011
# Modifications : 01/21/2011 - Changes for production mode  (LSJ)
#		: 
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
ELIG_DIR="/usr/lnk/elig_in"
ELIG_OUT="/usr/lnk/elig_in_1"
PRT_DIR="/usr/lnk/misc"
AUDIT_DIR="/usr/lnk/audit"
DATE="null"
MONTH_YR=`date +%m%y`
CLIENT="mh"
SYS=0068
SHELL="/usr/lnk/shell"
UPDATE_FILE=0
TEST_MODE=0
ACCUM451_RPT="ACCUM451ERR"
CONV_PDF="/usr/lnk/shell/conv_elig_rpts.sh"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: accum451.sh [-u] [-t] [-d <mmdd>]

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
#
# Convert report
conv_report()
{
        if test -s ${PRT_DIR}/${ACCUM451_RPT}
        then
                ${CONV_PDF} ${ACCUM451_RPT} ${PRT_DIR}
        fi
}

#
# Cleanup
cleanup()
{
        rm -f ${ELIG_DIR}/${CLIENT}l${DATE}
        mv ${ELIG_OUT}/${CLIENT}l${DATE} ${ELIG_OUT}/sys${SYS}
}

# Submit accum451 program
submit_accum451()
{

	if test -s ${ACCUM451IN}
	then
    		runcobol ${OBJ_DIR}/accum451 -s ${UPDATE_FILE}${TEST_MODE}  
	else
		echo
		echo "################### ERROR MESSAGE ###################"
		echo "      ${ACCUM451IN} DOES NOT EXIST"
		echo "   CHECK WITH BENEFITS or SUPERVISOR"
		echo "#####################################################"
		exit 1
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
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
    -t) TEST_MODE=1
        ;;
    -u) UPDATE_FILE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

umask 002

# Assign other variables

ACCUM451IN=${ELIG_DIR}/${CLIENT}l${DATE}
ACCUM451ERR=${PRT_DIR}/${ACCUM451_RPT}
export ACCUM451IN ACCUM451ERR

FG4AUD=${AUDIT_DIR}/LIMAUD

echo "Limit Update from File -- accum451"
date
echo "FILE DATE=$DATE"
submit_accum451 
date

# Error Report Print procedure
echo ""
echo "--> Converting Report..."
conv_report

# Cleanup
echo ""
echo "--> Doing Cleanup..."
cleanup

# Zip Archive Files
echo ""
echo "--> archive of limit file..."
${ZIP_PROG} -mj ${ELIG_OUT}/sys${SYS}/${CLIENT}${MONTH_YR}.zip ${ELIG_OUT}/sys${SYS}/${CLIENT}l${DATE}
 

exit 0
