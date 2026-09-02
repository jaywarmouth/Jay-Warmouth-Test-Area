#!/bin/ksh
#
# Program Name	: client_idcard_reports.sh
# Description	: Script for providing monthly reports in PDF format
#		  Command Line Arguments:
#		  -s <ref#> - 4 digit reference number
#		  -p <yyyymmdd> - period ending date
# Author	: Linda S. Jefferis
# Date		: 06/06/2011
# Modifications : 04/12/2012 - Add logic for sys0080
#		: 7/3/2012 - Changed wt for 0401
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
MISC_DIR="/usr/lnk/misc"
MAIL_PROG="/usr/bin/mutt"
OUT_DIR="/usr/lnk/shares/ftp-tmp"
WT_DIR="/usr/lnk/wt"
MAIL_CC="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: client_idcard_reports.sh -s <ref##> -p <yyyymmdd>
	-s <ref#> - 4-digit reference number 	(required) 
	-p <yyyymmdd> - period ending		(only required for select clients)

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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
    -s) shift
	if [ $# -le 0 ]
        then
          usage
        fi
        REF=$1
        ;;
    -p) shift
	if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
esac
  shift
done


# Parse environment variables
parse_env


case ${REF} in
   "0401")
	SEND_TO=${WT_DIR}/pcha-00
	a2ps -1Bl132 --print-anyway=1 --non-printable-format=blank -o - ${PO_DIR}/sys0075/spo0401/???CA08B-P.L6 | ps2pdf - ${OUT_DIR}/0401_IDCard_Detail_${DATE}.pdf
	scp ${OUT_DIR}/0401_IDCard_Detail_${DATE}.pdf ${SEND_TO}
	rm -f ${OUT_DIR}/0401_IDCard_Detail_${DATE}.pdf
	;;
   "80")
	SEND_TO=${WT_DIR}/lashp-03
	a2ps -1Bl132 --print-anyway=1 --non-printable-format=blank -o - ${PO_DIR}/sys0080/???CA08A-T.L6 | ps2pdf - ${OUT_DIR}/PAN_IDCard_Detail_${DATE}.pdf
        scp ${OUT_DIR}/PAN_IDCard_Detail_${DATE}.pdf ${SEND_TO}
        rm -f ${OUT_DIR}/PAN_IDCard_Detail_${DATE}.pdf
	;;
   *)	echo "-*> Invalid reference number..."
	exit 1
	;;
esac

exit 0
