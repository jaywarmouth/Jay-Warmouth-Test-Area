#!/bin/sh
#
# Program Name	: cycle_claims_refresh.sh
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
#		: 12/30/2015 - Related to TT8641-32; remove wharehosue distribution of BAL_RPT.
#		: 11/12/2019 - Change "a2ps" to "enscript"
#               : 07/28/2020 - CAB:10287 CI:13735; logic to copy file to secondary directory for AWS transfer. (DME)
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
MAIL_WHSE="DEDMSupport@pdmi.onmicrosoft.com"
MAIL_OPER="operations@pdmi.com"
TR_ERR=0
ZIP_PROG="/bin/gzip"
AWS_DIR="/usr/lnk/wt/oper-wt/CLAIM72PDM"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cycle_claims_refresh.sh -c <cycle type> -d <p/e - ccyymmdd>

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
	RPT_NAME="tweek"
	;;
     *) usage
	;;
   esac
   CL72_FILE="???CL72-${CYC_LET}-PDM"
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
	cp ${FNAME}.gz ${AWS_DIR}
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

date

echo "--> Running claim72pdm"
echo ""
${SHELL_DIR}/claim72pdm.sh -c ${CYCLE} > ${RPT_DIR}/${RPT_NAME}-claim72pdm 2>&1
enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/${RPT_NAME}-claim72pdm | ps2pdf - ${RPT_DIR}/${RPT_NAME}-claim72pdm.pdf
echo "Output from ${RPT_NAME}-claim72pdm process" | ${MAIL_PROG} -s "${RPT_NAME}-cycle - claims refresh" ${MAIL_OPER} -a ${RPT_DIR}/${RPT_NAME}-claim72pdm.pdf 

date

echo "--> claim72pdm completed"
echo ""
echo "--> Moving file for Warehouse"
echo ""
mv ${FILE_PATH}/${CL72_FILE} ${SQL_FILE}
FNAME=${SQL_FILE}
file_transfer


if [ $TR_ERR = 0 ]
then
	echo "The claims refresh file, ${SQL_FNAME}, is now available." | ${MAIL_PROG} -s "${CYCLE} CLAIMS REFRESH" -c ${MAIL_OPER} ${MAIL_WHSE} 
else
	echo "No extract file created. Look for possible issue." | ${MAIL_PROG} -s "${CYCLE} CLAIMS REFRESH" ${MAIL_OPER}
fi

date


exit 0
