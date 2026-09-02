#!/bin/sh
#
# Program Name	: email_inv_sum.sh
# Description	: Script for emailing (or providing in web transfer) PDF invoice summary reports
#		  Command Line Arguments:
#		  -s <ref#> - 4 digit reference number
#		  -d <mmdd> - p/e month and day for filenames
# Author	: Linda S. Jefferis
# Date		: 02/25/2009
# Modifications : 04/30/2009 - Added PDF convert process and web transfer logic
#		: 09/09/2009 - Added MAIL_CC for 0052  (LSJ)
#		: 12/18/2009 - Added logic for sys0124  (LSJ)
#		: 01/19/2010 - Logic change for NC Conversion and removed logic for terminated sys0107  (LSJ)
#		: 06/23/2010 - Added Ly Dang's email for sys0073 and sys0124
#		: 10/26/2010 - Added logic for sys0068  (LSJ)
#		: 06/14/2011 - Added sys0052 Network Report and removed email notification
#		: 04/04/2013 - Add logic for sys0158 (HPS)
#		: 05/08/2013 - As per email, changed email address for Mike Nault and Ly under 0124 and 0158
#		: 08/12/2013 - As per email, added srussell to MAIL_TO under 0073, 0124, and 0158
#		: 12/13/2013 - Add logic for sys0071
#		: 03/06/2014 - Added lking@qualitycarepartners.com for 0071
#		: 08/27/2014 - update email addresses for 73, 124, 158 (TT #11832-1)
#		: 11/17/2014 - TT #122831-1 and other termination cleanup.
#		: 11/24/2014 - As per email request from Ly Dang, updated email distribution for 0073, 0124, and 0158
#		: 07/06/2014 - TT:13455-19 - update HPS email address.
#		: 11/19/2015 - TT13455-46 - HPS email updates.
#		: 05/20/2016 - TT14942-76 - HPS email updates.
#		: 06/02/2016 - TT15075-5 remove termed sys0102 logic.
#		: 09/20/2016 - TT14942-123 - remove csacct and spalmer and replace with Jennifer Bowers jbowers@careservicesllc.com and AP@careservicesllc.com. (DME)
#		: 02/27/2018 - TT18139-9
#		: 07/05/2018 - TT18601-3
#		: 05/29/2019 - TT19347-8
#		: 10/17/2019 - Changes due to INLOG Conversion (Ticket 19988)
#		: 10/31/2019 - Changed for switch from a2ps ro enscript.
#		: 04/07/2020 - TT20396-2; add sys0184
#		: 04/07/2020 - fixed email command
#
# Variables Used:
PO_DIR="/usr/lnk/po"
MAIL_PROG="/usr/bin/mutt"
MAIL_SUBJ="Invoice Information"
MAIL_CC="operations@pdmi.com"
MAIL_TO="AP@careservicesllc.com,fpa@careservicesllc.com,csaccounting@careservicesllc.com"
MAIL_BCC="hps@pdmi.com"
REF="null"
DATE="null"
FILE_LOC="/usr/lnk/wrk"
WT_DIR="/usr/lnk/wt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: email_inv_sum.sh -s <ref##> -d <mmdd>
	-s <ref#> - 4-digit reference number 	(required) 
	-d <mmdd> - p/e month and day		(required)

ENDOFUSAGE
  exit 1
}

# Emailing Process
email_process()
{
	if test -s ${INV_SUM}
        then
		enscript -rlg -f Courier6 -a2- --non-printable-format=space -o - ${INV_SUM} | ps2pdf - ${INV_SUM}.pdf
		echo "Attached is the most recent invoice summary information." | ${MAIL_PROG} -s "${MAIL_SUBJ}" -c ${MAIL_CC} -b ${MAIL_BCC} ${MAIL_TO} -a ${INV_SUM}.pdf 
        else
                echo "-*> The file, $INV_SUM, is empty or does not exist..."
                exit 1
        fi
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


if [ $REF = "null" ]
then
	usage
fi
if [ $DATE = "null" ]
then
	usage
fi


case ${REF} in
   "0073")
	INV_SUM=${FILE_LOC}/73inv_sum${DATE}
	email_process
	;;
   "0124")
	INV_SUM=${FILE_LOC}/124inv_sum${DATE}
	email_process
	;;
   "0184")
	INV_SUM=${FILE_LOC}/184inv_sum${DATE}
	email_process
	;;
   "0189")
	INV_SUM=${FILE_LOC}/189inv_sum${DATE}
	email_process
	;;
   *)	echo "-*> Invalid reference number..."
	usage
	;;
esac

exit 0
