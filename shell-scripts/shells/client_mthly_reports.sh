#!/bin/ksh
#
# Program Name	: client_mthly_reports.sh
# Description	: Script for providing monthly reports in PDF format
#		  Command Line Arguments:
#		  -s <ref#> - 4 digit reference number
#		  -p <yyyymm> - period ending date
# Author	: Linda S. Jefferis
# Date		: 01/29/2010
# Modifications : 05/12/2010 - Removed TR_SYS and TR_DIR reference
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

usage: client_mthly_reports.sh -s <ref##> -p <yyyymmdd>
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
   "0368")
	MAIL_TO="calbrecht@co.wood.oh.us"
	SEND_TO=${WT_DIR}/wce-01
	a2ps -1Bl132 -o - ${PO_DIR}/sys0069/spo0368/???CL34A-P.L3 | ps2pdf - ${OUT_DIR}/0368_CL34_Summary.pdf
	a2ps -1Bl132 -o - ${PO_DIR}/sys0069/spo0368/???CL34B-P.L3 | ps2pdf - ${OUT_DIR}/0368_CL34_Detail.pdf
	a2ps -1Bl132 -o - ${PO_DIR}/sys0069/spo0368/???CL39A-P.L4 | ps2pdf - ${OUT_DIR}/0368_CL39_Summary.pdf
	a2ps -1Bl132 -o - ${PO_DIR}/sys0069/spo0368/???CL39B-P.L4 | ps2pdf - ${OUT_DIR}/0368_CL39_Detail.pdf
	a2ps -1Bl132 -o - ${PO_DIR}/sys0069/spo0368/???CL57A-P.L4 | ps2pdf - ${OUT_DIR}/0368_CL57_Summary.pdf
	a2ps -1Bl132 -o - ${PO_DIR}/sys0069/spo0368/???CL57B-P.L4 | ps2pdf - ${OUT_DIR}/0368_CL57_Detail.pdf
	scp ${OUT_DIR}/0368_*.pdf ${SEND_TO}
	rm -f ${OUT_DIR}/0368_*.pdf
	echo "The most recent monthly reports are now available in the wce-01 file transfer area" | ${MAIL_PROG} -s "Monthly Reports" -c ${MAIL_CC} ${MAIL_TO}
	;;
   *)	echo "-*> Invalid reference number..."
	exit 1
	;;
esac

exit 0
