#!/bin/sh
#
# Program Name	: zip-calmon.sh
# Description	: Zipping mon-cycle files to rptarch
#		  Command Line Arguments:
#		  -d <ccyymmdd> - m/e date
# Author	: Linda S. Jefferis
# Date		: 05/13/99
# Modifications : 03/09/2000 - Added claim112 files  (LSJ)
#		: 11/15/2000 - Changes for new version of pkzip  (LSJ)
#		: 01/09/2002 - Added ZIP_PROG and ${CYCLE} prefix to zip filenames  (LSJ)
#		: 01/17/2002 - Removed the PRO-SYN-REBATE file. Rebate03 is no longer run  (LSJ)
#		: 01/09/2004 - Addition of claim212 files  (LSJ)
#		: 01/09/2004 - Addition of rpt files  (LSJ)
#		: 04/06/2004 - Addition of rebate12 and rebate13 files  (LSJ)
#		: 11/10/2004 - Addition of formulary02 rpt file  (LSJ)
#		: 03/21/2005 - Changes for newcycle  (LSJ)
#		: 07/05/2005 - Addition of -s option and card emboss files (LSJ)
#		: 08/09/2005 - Changed rpt files to cmon-*  (LSJ)
#		: 10/28/2005 - Changes for Linux  (LSJ)
#		: 07/06/2006 - Removed references for claim112 files  (LSJ)
#		: 08/17/2006 - Added claim106 files  (LSJ)
#		: 09/28/2006 - Added "-follow" to find sys?? commands  (LSJ)
#		: 09/28/2006 - Changed sys?? to sys????  (LSJ)
#		: 01/08/2007 - Added "files" section to zip EMBOS00MAS.cd07  (LSJ)
#		: 05/17/2007 - Added files for claim171  (LSJ)
#		: 06/06/2007 - Changed ${PREFIX}CL171-M-QCP to ???CL171-M-QCP  (LSJ)
#		: 11/13/2007 - Addition of INLGWRK files  (LSJ)
#		: 10/08/2008 - Changed names for claim106 related files  (LSJ)
#		: 06/30/2009 - Changes for "W" claim106 files  (LSJ)
#		: 01/13/2011 - Changed input date format and other miscellaneous cleanup
#		: 04/05/2011 - Added medco rebate files
#		: 07/08/2013 - Removed inactives
#		: 09/19/2013 - Removed rebate files
#               : 09/29/2014 - logic for tweek "X" files (TT #11688-3)
#		: 03/03/2016 - logic for week "W" files.
#		: 01/03/2018 - TT:1730-57; remove logic for tweek files.
#               : 1/17/2018 - TT1730-58; remove "pay" logic.
#		: 02/02/2018 - TT18170-2; add "tweek" logic back.
#		: 02/08/2021 - Remove cardh08 process
#		: 06/30/2022 - Removed EMBOS00MAS.cd07
#
# Variables Used:
PO_DIR="/usr/lnk/po"
RPTARCH="/usr/lnk/rptarch"
TAPE_DIR="/usr/lnk/tapes"
KEY_DIR="/usr/lnk/keys"
CRD_DIR="/usr/upd/crd_01"
RPT_DIR="/usr/lnk/rpt"
GRP_DIR="/usr/upd/grp"
CYCLE="calmon"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-mon.sh -d <m/e date(ccyymmdd)>  
	-d <mmddyy>	m/e date

ENDOFUSAGE
  exit 1
}


# REPORT FILES
zip_reports()
{
	cd ${PO_DIR}
	find sys???? -follow -name "*CA07*X.*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	find sys???? -follow -name "*CA07*T.*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	mv reports-${DATE}.zip ${RPTARCH}/${CYCLE}/${CYCLE}-reports-${DATE}.zip
}


# KEY FILES
zip_keys()
{
	cd ${RPTARCH}/${CYCLE}
	find ${KEY_DIR} -follow -name "CARDH07KEY.cmtweek*" -print | ${ZIP_PROG} -j ${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CARDH07KEY.cmtwice*" -print | ${ZIP_PROG} -j ${CYCLE}-keys-${DATE}.zip -@
}


# MISC FILES
zip_other()
{
	${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip ${GRP_DIR}/INLGWRKMAS-CRDS-?
}


# RPT FILES
zip_rpt()
{
        find ${RPT_DIR} -follow -name "cmon-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-rpt-${DATE}.zip -@
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

zip_reports
zip_keys
zip_other
zip_rpt

exit 0
