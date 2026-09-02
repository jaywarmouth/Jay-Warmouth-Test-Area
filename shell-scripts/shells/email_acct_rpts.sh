#!/bin/sh
#
# Program Name	: email_acct_rpts.sh
# Description	: Email check run balancing reports to Accounting
# Author	: Linda S. Jefferis
# Date		: 04/30/2009
# Modifications : 05/14/2009 - Added Processing Fee Invoice for week-cycle
#		: 05/26/2009 - Removed PMI Processing Fee Invoice - run from RS
#		: 09/18/2009 - Changes for switch to new check run
#		: 07/07/2011 - Changed CL88 to be emailed as .txt and not converted to PDF.
#               : TT13915-64 - Removal of MRKT-RPT related files
#
# Variables Used:
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="finance@pdmi.com"
MAIL_CC="operations@pdmi.com"
MISC_DIR="/usr/lnk/misc"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: email_acct_rpts.sh <cycle> 
	<cycle> is chk

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 1 ]
then
   usage
   exit 2
fi

CYCLE=$1

cd ${MISC_DIR}

case ${CYCLE} in
  "chk")
	enscript -rBj -f Courier9 -o - PRINT-SUSP002  | ps2pdf - PRINT-SUSP002.pdf
	enscript -rBj -a2- -f Courier9 -o - CL07-C-TOTALS | ps2pdf - CL07-C-TOTALS.pdf
	enscript -RBj -a2- -o - CL37-C-TOTALS | ps2pdf - CL37-C-TOTALS.pdf
	cp ???CL88-C CL88-C.txt
	enscript -rBj -a2- -f Courier9 -o - SYS-CHK-TOTALS | ps2pdf - SYS-CHK-TOTALS.pdf
	echo "Check Run reports are attached." | ${MAIL_PROG} -s "Check Run Reports" ${MAIL_TO} -a PRINT-SUSP002.pdf -a CL07-C-TOTALS.pdf -a CL37-C-TOTALS.pdf -a CL88-C.txt -a SYS-CHK-TOTALS.pdf
	rm -f CL88-C.txt
	;;
  *) usage
	;;
esac

exit 0
