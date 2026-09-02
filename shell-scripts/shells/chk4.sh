#!/bin/sh
#
# Program Name	: chk4.sh
# Description	: Check Run Report Processing - Payment Reconciliation
#                 Runs: claim92, reconx12
#                 Command line:
#                 -f Sends alternate CLAIM00MAS to shells
# Author	: Linda S. Jefferis
# Date		: 09/18/2009
# Modifications : 09/26/2012 - Added PDF and email logic
#		: 06/27/2014 - add "-v" option to reconx12.sh command line
#		: 11/11/2019 - Change "a2ps" to "enscript"
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"
FILE="/usr/lnk/tmp/CLWRK00MAS.chk"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: chk4.sh [-f <filename>]

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

# Check command line validity
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE=$1
        ;;
  esac
  shift
done

if [ ${FILE} = "null" ]
then
   usage
else
   ${SHELL_DIR}/reconx12.sh -f ${FILE} -i -v > ${RPT_DIR}/chk-reconx12-ind 2>&1

   # Convert output files to PDF and email
   echo "### chk-reconx12-ind ###" > ${RPT_DIR}/chk-chk4
   cat ${RPT_DIR}/chk-reconx12-ind >> ${RPT_DIR}/chk-chk4
   enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/chk-chk4 | ps2pdf - ${RPT_DIR}/chk-chk4.pdf
   if test -s ${MISC_DIR}/???-V5010-X12-IR-ERR
   then
	enscript -rgj -f Courier9 --non-printable-format=space -o - ${MISC_DIR}/???-V5010-X12-IR-ERR | ps2pdf - ${MISC_DIR}/???-V5010-X12-IR-ERR.pdf
	echo "Output from reconx12-ind.sh process" | ${MAIL_PROG} -s "Check Run - chk4" ${MAIL_TO} -a ${RPT_DIR}/chk-chk4.pdf -a ${MISC_DIR}/???-V5010-X12-IR-ERR.pdf 
	rm -f ${MISC_DIR}/???-V5010-X12-IR-ERR.pdf
   else
	echo "Output from reconx12-ind.sh process" | ${MAIL_PROG} -s "Check Run - chk4" ${MAIL_TO} -a ${RPT_DIR}/chk-chk4.pdf 
   fi


   ${SHELL_DIR}/reconx12.sh -f ${FILE} -v > ${RPT_DIR}/chk-reconx12 2>&1

   # Convert output files to PDF and email
   echo "### chk-reconx12 ###" > ${RPT_DIR}/chk-chk4
   cat ${RPT_DIR}/chk-reconx12 >> ${RPT_DIR}/chk-chk4
   enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/chk-chk4 | ps2pdf - ${RPT_DIR}/chk-chk4.pdf 
   if test -s ${MISC_DIR}/???-V5010-X12-ERR
   then
	enscript -rgj -f Courier9 --non-printable-format=space -o - ${MISC_DIR}/???-V5010-X12-ERR | ps2pdf - ${MISC_DIR}/???-V5010-X12-ERR.pdf
	echo "Output from reconx12.sh process" | ${MAIL_PROG} -s "Check Run - chk4" ${MAIL_TO} -a ${RPT_DIR}/chk-chk4.pdf -a ${MISC_DIR}/???-V5010-X12-ERR.pdf 
	rm -f ${MISC_DIR}/???-V5010-X12-ERR.pdf
   else
	echo "Output from reconx12.sh process" | ${MAIL_PROG}  -s "Check Run - chk4" ${MAIL_TO} -a ${RPT_DIR}/chk-chk4.pdf 
   fi

fi

exit 0
