#!/bin/sh
#
# Program Name	: restack_claim96.sh
# Description	: Restack claim96 
#		  Command Line Arguments:
#		  -d <ccyymmdd> - audit file date
# Author	: Linda S. Jefferis
# Date		: 02/08/2013
#		: 11/10/2013 - Added ".prod10"
#		: 03/22/2016 - Removed ".prod10" so this process can be run on Prod10.
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
AUD_DIR="/usr/lnk/audit"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: restack_claim96.sh -d ccyymmdd
	where ccyymmdd is date of audit file

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
  esac
  shift
done


${SHELL_DIR}/claim96.sh -a rst -d ${DATE} -p ${AUD_DIR} > ${RPT_DIR}/rst-claim96 2>&1

a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/rst-claim96 | ps2pdf - ${RPT_DIR}/rst-claim96.pdf

echo "Output from restack_claim96.sh process" | ${MAIL_PROG} -a ${RPT_DIR}/rst-claim96.pdf -s "Restack - claim96" ${MAIL_TO}

exit 0
