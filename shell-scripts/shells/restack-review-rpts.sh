#!/bin/sh
#
# Program Name	: restack-review-rpts.sh
# Description	: Procedures for restack review and auditing.
#		  -d <restack date - ccyymmdd>
# Author	: Linda S. Jefferis
# Date		: 02/20/2014
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE_DIR="/usr/lnk/tmp"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
RSTK_DATE="null"
REMOTE="husk:/usr/lnk/shares/ftp-tmp/restack"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: restack-review-rpts.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RSTK_DATE=$1
        ;;

  esac
  shift
done

if [ $RSTK_DATE = "null" ]
then
	usage
	exit
fi

${SHELL_DIR}/restack12.sh -b ${RSTK_DATE} > ${RPT_DIR}/rst-restack12 2>&1
${SHELL_DIR}/restack13.sh -d ${RSTK_DATE} > ${RPT_DIR}/rst-restack13 2>&1

a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/rst-restack12 | ps2pdf - ${RPT_DIR}/rst-restack12.pdf
a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/rst-restack13 | ps2pdf - ${RPT_DIR}/rst-restack13.pdf

scp ${RPT_DIR}/rst-restack12 ${REMOTE}
scp ${RPT_DIR}/rst-restack13 ${REMOTE}
scp ${FILE_DIR}/RESTACK12-* ${REMOTE}
scp ${FILE_DIR}/RESTACK13_* ${REMOTE}

echo "Output from restack-review-rpts.sh process" | ${MAIL_PROG} -a ${RPT_DIR}/rst-restack12.pdf -a ${RPT_DIR}/rst-restack13.pdf -s "Restack Procedures" ${MAIL_TO}

exit 0
