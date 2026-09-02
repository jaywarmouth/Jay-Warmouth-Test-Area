#!/bin/sh
#
# Program Name	: tr_lvhn_files.sh
# Description	: LASH Accumulator Processing 
#		  -t <accum|term>
#		  -d <ccyymmdd>
#		   where ccyymmdd is date of lvl and lve-term PDF files
#		   if this option not used assumes current date.
# Author	: Linda S. Jefferis
# Date		: 02/03/2014
# Modifications : 12/27/2016 - Added the Eligibility error report to transfers. (TT:16196-4; DME)
#		: 03/03/2020 - changing TR_ID to refelct "LVHNL" (TT:19774-4;DME)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
REMOTE_DIR="/usr/lnk/wt/oper-wt/EligReports"
ACCUM_FILE="null"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="LVHNL"
DATE=`date +%Y%m%d`


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tr_lvhn_files.sh 

ENDOFUSAGE
  exit 1
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
    -t) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FTYPE=$1
	;;
  esac
  shift
done

case ${FTYPE} in
  "accum")
	ACCUM_FILE="${DATE}-??????-lvl*.pdf"
	echo "--> transferring file"
	${TR_PROG} ${TR_ID} ${REMOTE_DIR}/${ACCUM_FILE}
	;;
  "term")
	TERM_LIST="${DATE}-??????-lve*.pdf"
	echo "--> transferring files"
	${TR_PROG} ${TR_ID} ${REMOTE_DIR}/${TERM_LIST}
	;;
  *) usage
	;;
esac


exit 0
