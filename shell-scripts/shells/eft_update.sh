#!/bin/sh
#
# Program Name	: eft_update.sh
# Description	: Run eft01.sh update and email report to Pharmacy
#		  Command Line:
#		  -d <ccyymmdd> - date on EFT file provided in email notification
# Author	: Linda S. Jefferis
# Date		: 05/12/2010
# Modifications : 08/07/2012 - Changed procedures for not emialing report to Pharmacy.  Operations will instead attached PDF report in CRM task assigned to Benefits.
#		: 10/26/2012 - Added input date logic and "-f" to eft01 run
#		: 11/16/2012 - Fixed EFT-RPT file name
#
# Variables Used:
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
MISC_DIR="/usr/lnk/misc"
SHELL="/usr/lnk/shell"
EFT_DIR="/usr/lnk/wt/EFT"
RPT_DIR="/usr/lnk/rpt"
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: eft_update.sh 

ENDOFUSAGE
  exit 1
}

# Set EFT filename
set_filenames()
{
	EFT_FILE=${EFT_DIR}/EFT-${FILE_DATE}.txt
	EFT_RPT=${MISC_DIR}/EFT-RPT-${DATE}
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
        FILE_DATE=$1
	set_filenames
        ;;
  esac
  shift
done

${SHELL}/eft01.sh -f ${EFT_FILE} > ${RPT_DIR}/eft01 2>&1

enscript -rg -f Courier9 --non-printable-format=space -o - $EFT_RPT  | ps2pdf - $EFT_RPT.pdf
echo "Attached is an EFT review report. Create new TT under Ticket #2351 with this report included and send to Benefits." | ${MAIL_PROG} -a $EFT_RPT.pdf -s "EFT Review Report" ${MAIL_TO}

exit 0
