#!/bin/sh
#
# Program Name	: cycle-inlog01.sh
# Description	: Cycle INLOG Extract Procedure
#		  Command Line Arguments:
#		  -c <week|pay|twice|chk|cmon-p|cmon-t|cmon-x|mweek>
#		  -d <p/e date - ccyymmdd>
# Author	: Linda S. Jefferis
# Date		: 10/13/2009
# Modifications : 12/03/2009 - Added cmon-p and cmon-t option logic
#		: 12/14/2009 - Addition of mweek option logic
#		: 04/08/2010 - Changes for location of files for warehouse
#		: 06/09/2010 - Temporary logic for INLOGRB-O name
#		: 11/04/2010 - Changes for NEW tweek cycle
#		: 01/07/2011 - Changed WH_DIR and other logic for no longer needing files for STORM warehouse.
#		: 09/30/2014 - Add logic for INLOGRB-CRDS-X file (TT #11688-3)
#		: 02/09/2016 - TT13915-19 "cmon-w" logic
#		: 10/14/2019 - TT19988-22; exit coding
#		: 05/04/2020 - Change request 10160; Add file copy for AWS transfers. (DME)
#		: 02/21/2024 - Halo #13051 - for check run ONLY, do not send ticket email to DEDMSupport@pdmi.onmicrosoft.com
#				also removed logic for inactive "cmon-w" and "cmon-p"
#		: 10/14/2025 - HALO 72500 - remove codiong for "cmon-t"
#

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
OUT_DIR="misc"
GRP_DIR="/usr/upd/grp"
SQL_DIR="/usr/lnk/wt/sqlimports"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="DEDMSupport@pdmi.onmicrosoft.com, operations@pdmi.com"
MAIL_OPER="operations@pdmi.com"
CYCLE="null"
ZIP_PROG="/bin/gzip"
TR_ERR=0
RETVAL=0
AWS_DIR2="/usr/lnk/wt/oper-wt/INLOG"
AWS_DIR="s3://ga-internal-transfers/PDMI/Extracts/"
#AWS_CP="/usr/local/bin/aws s3 cp"
AWS_CP_OPTS="--only-show-errors"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cycle-inlog01.sh

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
# Transfer file
file_transfer()
{
if test -s ${FNAME}
then
        ${ZIP_PROG} ${FNAME}
        cp ${FNAME}.gz ${AWS_DIR2}
        /usr/local/bin/aws s3 cp ${FNAME}.gz ${AWS_DIR} ${AWS_CP_OPTS}
        mv ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "${FNAME} not copied"
                TR_ERR=1
        fi
else
        echo "${FNAME} does not exist"
        TR_ERR=1
fi
}

#
# Set INLOG filenames based on CYCLE
set_filenames()
{
   WH_DIR=/usr/lnk/sqlimports/misc
   case ${CYCLE} in
     "week")
        INLOGRB="${WH_DIR}/INLOGRB-W"
        INLGWRK="${GRP_DIR}/INLGWRKMAS-W"
        CYCLE_SUBJ="WEEK-CYCLE"
        ;;
     "tweek")
        INLOGRB="${WH_DIR}/INLOGRB-X"
        INLGWRK="${GRP_DIR}/INLGWRKMAS-X"
        CYCLE_SUBJ="TWEEK-CYCLE"
        ;;
     "pay")
        INLOGRB="${WH_DIR}/INLOGRB-P"
        INLGWRK="${GRP_DIR}/INLGWRKMAS-P"
        CYCLE_SUBJ="PAY-CYCLE"
        ;;
     "twice")
        INLOGRB="${WH_DIR}/INLOGRB-T"
        INLGWRK="${GRP_DIR}/INLGWRKMAS-T"
        CYCLE_SUBJ="TWICE-CYCLE"
        ;;
     "chk")
        INLOGRB="${WH_DIR}/INLOGRB-C"
        INLGWRK="${GRP_DIR}/INLGWRKMAS-C"
        CYCLE_SUBJ="CHECK RUN"
        ;;
     "cmon-x")
        INLOGRB="${WH_DIR}/INLOGRB-CRDS-X"
        INLGWRK="${GRP_DIR}/INLGWRKMAS-CRDS-X"
        CYCLE_SUBJ="TWEEK ID CARDS"
        ;;
     *) usage
	;;
   esac
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
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

parse_env

if [ ${CYCLE} = "null" ]
then
	usage
fi

set_filenames


if test -a ${INLOGRB}
then
   rm -f ${INLOGRB}
fi
${SHELL_DIR}/inlog01.sh -i ${INLGWRK} -o ${INLOGRB} > ${RPT_DIR}/${CYCLE}-inlog01 2>&1
RETVAL=$?
if [ $RETVAL != 0 ]
then
	echo "EXIT CODE=$RETVAL"
	exit $RETVAL
fi

mv ${INLOGRB} ${INLOGRB}-${DATE}
FNAME=${INLOGRB}-${DATE}
file_transfer
if [ $TR_ERR = 0 ]
then
	case ${CYCLE} in
	  "week" | "tweek" | "pay" | "twice" | "cmon-x")	
		cat ${RPT_DIR}/${CYCLE}-inlog01 | ${MAIL_PROG} -s "${CYCLE_SUBJ} INLOG EXTRACT" ${MAIL_TO}
		;;
	esac
else
	RETVAL=99
	echo "Error with file_transfer. Look for possible issue." | ${MAIL_PROG} -s "${CYCLE_SUBJ} INLOG EXTRACT" ${MAIL_OPER}
fi

echo "EXIT CODE=$RETVAL"
exit $RETVAL
