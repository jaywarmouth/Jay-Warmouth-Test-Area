#!/bin/sh
#
# Program Name	: client_cycle_reports.sh
# Description	: Script for invoice emailing in PDF format
#		  Command Line Arguments:
#		  -s <ref#> - 4 digit reference number
#		  -p <yyyymmdd> - period ending date
# Author	: Linda S. Jefferis
# Date		: 05/11/2009
# Modifications : 05/14/2009 - Added logic for sys0054
#		: 05/19/2009 - Added logic for sys0061 and spo0368
#		: 09/18/2009 - Added logic for sys0001 (Suspended Report)
#		: 01/07/2010 - Added logic for MEDD (spo0435)
#		: 03/23/2010 - Added logic for spo0347
#		: 05/03/2010 - Added ault-34 for 435 for distribution
#		: 05/10/2010 - Changed distribution for 48 and 53 as per email request from Chris Scarpino.
#		: 05/19/2010 - The previous change was incorrect, put back ault-24 and removed ault-25 and ault-35
#		: 08/31/2010 - Added logic for sys0062
#		: 11/1/2010 - Changes for Aultcare cycle conversion
#		: 01/22/2011 - Updated Tammy Corral's email address
#		: 02/07/2011 - Added logic for spo1049
#		: 06/14/2011 - Added sys0082 Suspend report
#		: 06/26/2011 - Add logic for sys0058 and spo0295
#		: 08/02/2011 - Added logic for PRM Retail/Mail report
#		: 02/08/2012 - Changed 0058 and 0295 to deliver to urx-04
#		: 05/17/2012 - Add wt locations for 0435 and 1049
#		: 09/09/2013 - Added URX-Differentials under 0058
#		: 01/10/2014 - Addition of sys0161 logic
#		: 07/11/2014 - TT #11519-1
#		: 11/17/2014 - TT #12283-1 and other termination cleanups.
#		: 11/19/2015 - Remove ault-24 from report uploads. (TT:14622-1 DME)
#		: 6/7/2017 - TT15669-25; add distribution to Jennifer Bauldry.
#               : 4/5/2018 - TT18486-54; changes for AHF terminations/runout.
#		: 11/11/2019 - Change "a2ps" to "enscript" and remove inactive logic.
#		: 11/20/2020 - Removal of inactive URX-Differentials under 0058
#

# Variables Used:
PO_DIR="/usr/lnk/po"
MISC_DIR="/usr/lnk/misc"
OUT_DIR="/usr/lnk/wrk"
WT_DIR="/usr/lnk/wt"
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: client_cycle_reports.sh -s <ref##> -p <yyyymmdd>
	-s <ref#> - 4-digit reference number 	(required) 
	-p <yyyymmdd> - period ending		(only required for select clients)

ENDOFUSAGE
  exit 1
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


case ${REF} in
   "0058")
	if test -s ${PO_DIR}/sys0058/???CL16A-P.P2
	then
		SEND_TO=${WT_DIR}/urx-04
		enscript -RBj -o - ${PO_DIR}/sys0058/???CL16A-P.P2 | ps2pdf - ${OUT_DIR}/0058_Claim_Invoice_${DATE}.pdf
		enscript -RBj -o - ${PO_DIR}/sys0058/???CL17A-P.P2 | ps2pdf - ${OUT_DIR}/0058_Admin_Invoice_${DATE}.pdf
		cp ${OUT_DIR}/0058_Claim_Invoice_${DATE}.pdf ${SEND_TO}
		cp ${OUT_DIR}/0058_Admin_Invoice_${DATE}.pdf ${SEND_TO}
		rm -f ${OUT_DIR}/0058_*.pdf
	else
		 echo "There is no invoice to send..."
	fi
	;;
   "0295")
	if test -s ${PO_DIR}/sys0002/spo0295/???CL17B-P.P2
	then
		SEND_TO=${WT_DIR}/urx-04
		enscript -RBj -o - ${PO_DIR}/sys0002/spo0295/???CL17B-P.P2 | ps2pdf - ${OUT_DIR}/0295_Admin_Invoice_${DATE}.pdf
		cp ${OUT_DIR}/0295_Admin_Invoice_${DATE}.pdf ${SEND_TO}
		rm -f ${OUT_DIR}/0295_Admin_Invoice_${DATE}.pdf
	else
		 echo "There is no invoice to send..."
	fi
	;;
   "0082")
	if test -s ${PO_DIR}/sys0082/SUSP.S02
	then
		SEND_TO=${WT_DIR}/wbs-01
		enscript -RBj -o - ${PO_DIR}/sys0082/SUSP.S02 | ps2pdf - ${OUT_DIR}/WBS_Suspend_Report_${DATE}.pdf
		cp ${OUT_DIR}/WBS_Suspend_Report_${DATE}.pdf ${SEND_TO}
		rm -f ${OUT_DIR}/WBS_Suspend_Report_${DATE}.pdf
	else
		echo "There is no Suspend Report for PRM..."
	fi
	;;	
   *)	echo "-*> Invalid reference number..."
	exit 1
	;;
esac

exit 0
