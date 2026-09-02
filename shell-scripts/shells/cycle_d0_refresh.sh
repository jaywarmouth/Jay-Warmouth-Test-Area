#!/bin/ksh
#
# Program Name	: cycle_d0_refresh.sh
# Description	: Twice-Cycle Report and Update 
# NOTE		: The tweek option creates file with sys0083 and "X" cycle systems combined.
#		  Command Line Arguments:
#		  -c <pay|twice|week|tweek>
#		  -d <p/e date - ccyymmdd>
# Author	: Linda S. Jefferis
# Date		: 06/07/2010
# Modifications : 11/04/2010 - Changes for NEW tweek cycle
#		: 11/12/2010 - Changes for specially handling tweek balance report for sys0083 totals.
#		: 01/07/2011 - Removed logic for the special handling of the tweek balance report. System 83 now a "X" cycle type.
#		: 01/07/2011 - Remove special logic for "Storm" warehouse.
#		: 04/05/2011 - Added PDF conversion and email of claim72pdm output file.
#		
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE_PATH="/usr/lnk/tmp"
DATE="null"
CYCLE="null"
OUT_DIR="claims"
SQL_DIR="/usr/lnk/wt/sqlimports"
MAIL_PROG="/usr/bin/mutt"
BAL_RPT_DIR="/usr/lnk/misc"
MAIL_WHSE="warehouse@pdmi.com"
MAIL_OPER="operations@pdmi.com"
TR_ERR=0
ZIP_PROG="/bin/gzip"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cycle_d0_refresh.sh -c <cycle type> -d <p/e - ccyymmdd>

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

#
# Set filenames
set_filenames()
{
   RPT_NAME=$CYCLE
   case ${CYCLE} in
     "pay")
	CYC_LET="P"
	SQL_FNAME="D0BIWKCLMS"
	;;
     "twice")
	CYC_LET="T"
	SQL_FNAME="D0BIMOCLMS"
	;;
     "week")
	CYC_LET="W"
	SQL_FNAME="D0WEEKCLMS"
	;;
     "tweek")
	CYC_LET="X"
	SQL_FNAME="D0MIDBIMOCLMS"
	;;
     *) usage
	;;
   esac
   CL72_FILE="???CL72CONV-${CYC_LET}-PDM"
   BAL_RPT="???CL16-SYS-INV-${CYC_LET}"
   NEW_BAL_RPT="D0CL16-SYS-INV-${CYC_LET}"
}


#
# Transfer file
file_transfer()
{
if test -e ${FNAME}
then
        ${ZIP_PROG} ${FNAME}
        mv ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "${FNAME} not copied"
		TR_ERR=1
        fi
else
        echo "${FNAME} does not exist"
fi
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 4 ]
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
	;;
    -d) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	DATE=$1
	;;
  esac
  shift
done

if [ ${CYCLE} = "null" ]
then
        usage
fi

parse_env

set_filenames

SQL_FILE=${SQLIMPORTS}/${OUT_DIR}/${SQL_FNAME}-${DATE}
WH_BAL_RPT=${SQLIMPORTS}/${OUT_DIR}/${NEW_BAL_RPT}-${DATE}

date

echo "--> Running claim72pdmconv"
echo ""
${SHELL_DIR}/claim72pdmconv.sh -c ${CYCLE} > ${RPT_DIR}/${RPT_NAME}-claim72pdmconv 2>&1
a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/${RPT_NAME}-claim72pdmconv | ps2pdf - ${RPT_DIR}/${RPT_NAME}-claim72pdmconv.pdf
echo "Output from ${RPT_NAME}-claim72pdmconv process" | ${MAIL_PROG} -a ${RPT_DIR}/${RPT_NAME}-claim72pdmconv.pdf -s "${RPT_NAME}-cycle - D0 claims refresh" ${MAIL_OPER}

date

echo "--> claim72pdmconv completed"
echo ""
echo "--> Moving file for Warehouse"
echo ""
mv ${FILE_PATH}/${CL72_FILE} ${SQL_FILE}
FNAME=${SQL_FILE}
file_transfer

cp ${BAL_RPT_DIR}/${BAL_RPT} ${WH_BAL_RPT}
FNAME=${WH_BAL_RPT}
file_transfer

if [ $TR_ERR = 0 ]
then
	echo "The D0 claims refresh file, ${SQL_FNAME}, is now available." | ${MAIL_PROG} -s "${CYCLE} D0 CLAIMS REFRESH" -c ${MAIL_OPER} ${MAIL_WHSE} 
else
	echo "No extract file created. Look for possible issue." | ${MAIL_PROG} -s "${CYCLE} D0 CLAIMS REFRESH" ${MAIL_OPER}
fi

date


exit 0
