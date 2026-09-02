#!/bin/sh
#
# Program Name	: zip-pay.sh
# Description	: Zipping pay-cycle files to rptarch
#		  Command Line Arguments:
#		  -d <ccyymmdd> - p/e date
# Author	: Linda S. Jefferis
# Date		: 05/13/99
# Modifications : 07/02/99 - changed misc zip file to go to cycle sub-directory in rptarch instead of the misc directory  (LSJ)
#		: 09/17/99 - Added zip of po/misc/???CL68  (LSJ)
#		: 11/16/99 - Added files from run of claim116  (LSJ)
#		: 03/06/00 - Added CL44 and files from claim117  (LSJ)
#		: 03/14/00 - Added SUSPWRKMAS  (LSJ)
#		: 05/12/00 - Added INLGWRKMAS and new xp files  (LSJ)
#		: 05/18/00 - Added SUMA-DED tape file  (LSJ)
#		: 05/18/00 - Removed claim60 and claim61  (LSJ)
#		: 06/29/00 - Added claim08 files  (LSJ)
#		: 09/04/00 - Changed zip of CL68 misc files  (LSJ)
#		: 10/26/00 - Added ???LIMINVFILE under misc files  (LSJ)
#		: 11/14/00 - Added ???LIM12.LET and ???LIM12.RPT  (LSJ)
#		: 11/15/00 - Changes for new version of pkzip  (LSJ)
#		: 11/15/00 - Changed name of CHECK00WRK.cycle  (LSK)
#		: 11/22/00 - Added CL113 tape file  (LSJ)
#		: 04/03/01 - Added CL119 tape and key files  (LSJ)
#		: 06/13/01 - Added CL94 tape and key files  (LSJ)
#		: 08/02/01 - Removed CHKINVFILE and MKTINVFILE  (LSJ)
#		: 08/16/01 - Changed claims and group path to /usr/upd  (LSJ)
#		: 09/12/01 - Added ???MKTINV and ???MKTDET files  (LSJ)
#		: 01/08/02 - Changed pkzip to ${ZIP_PROG}  (LSJ)
#		: 01/08/02 - Added ${CYCLE} prefix to zip filenames  (LSJ)
#		: 02/07/02 - Added ???CL08UHMO file under tapes zip  (LSJ)
#		: 03/20/02 - Added -s required option and associated logic  (LSJ)
#		: 04/25/02 - Added new Rented Network files  (LSJ)
#		: 05/01/02 - Added TMP_DIR and associated logic  (LSJ)
#		: 05/15/02 - Changed ???CL72PDM to BIWKCLMS  (LSJ)
#		: 08/22/02 - Changed MKDET to INV02.L7  (LSJ)
#		: 12/06/02 - Added /usr/lnk/misc/CL??-TOTALS  (LSJ)
#		: 05/29/03 - Added zip of rpt files  (LSJ)
#		: 05/29/03 - Changes for RNT01 and RNT02 reports (LSJ)
#		: 10/09/03 - Added Reconx12 files  (LSJ)
#		: 12/18/03 - Addition of ???CL07-ZEROCHK and CL127-TOTALS (LSJ)
#		: 12/19/03 - Addition of claim123 report files and key file  (LSJ)
#		: 01/29/04 - Addition of claim128 reports and key files(Ultimed)  (LSJ)
#		: 02/17/04 - Changed zip of inv???? to inv*  (LSJ)
#		: 03/23/2004 - Addition of NHIN-X12 tape file  (LSJ)
#		: 04/06/2004 - Changes for CL44 filename change  (LSJ)
#		: 08/12/2004 - Additions for claim124 and claim130 tape files and keys  (LSJ)
#		: 12/30/2004 - Changes for newcycle filenames  (LSJ)
#		: 02/03/2005 - Added PRINT-CLAIM59-CYCLE-P  (LSJ)
#		: 05/09/2005 - Changes for KEY file name changes  (LSJ)
#		: 09/13/2005 - Removed CL119 references  (LSJ)
#		: 10/28/2005 - Changes for Linux  (LSJ)
#		: 11/08/2005 - Addition of ???-P-X12-ERR  (LSJ)
#		: 01/12/2006 - Addition of SYSTE00MAS  (LSJ)
#		: 02/13/2006 - Change of CLAIM109KEY  (LSJ)
#		: 02/20/2006 - Changed SUSPWRKMAS SUSPWRKMAS-P  (LSJ)
#		: 05/30/2006 - General cleanup  (LSJ)
#		: 10/09/2006 - Changes for 4-digit system #  (LSJ)
#		: 01/11/2007 - Removed invoice02 files  (LSJ)
#		: 06/06/2007 - Changed CLAIM130KEY* CLAIM130KEY-P*  (LSJ)
#		: 08/15/2007 - Removed CLAIM106KEY, CLAIM12KEY, CL124, and PRINT-CL116i files  (LSJ)
#		: 01/04/2008 - Addition of CLAIM111RXKEY  (LSJ)
#		: 01/04/2008 - Addition of files for claim109eb  (LSJ)
#		: 08/19/2008 - changed CL44 filename  (LSJ)
#		: 11/10/2008 - Added QISS-claim132 files  (LSJ)
#		: 03/19/2009 - Added claim133 files  (LSJ)
#		: 09/09/2009 - Changed zip for claim133 files for new BAS directory  (LSJ)
#		: 09/18/2009 - Changes for switch to new check run  (LSJ)
#		: 09/23/2009 - Changes for SUSP report names
#		: 01/27/2010 - Added CLMRT01 files for ARX
#		: 07/02/2010 - Added separate RXEOB file names selection  (LSJ)
#		: 08/31/2010 - Added files for new clncpdp01.sh process  (LSJ)
#		: 01/12/2011 - Changed input date format and several other miscellaneous changes
#		: 02/02/2011 - Added files for new claim109gran process  (LSJ)
#		: 06/30/2011 - Added files for claim109d0 (LSJ)
#		: 09/01/2011 - Add "D0" prefix to BIWKCLMS file name
#		: 01/10/2012 - Added claim111d0 files
#		: 09/24/2012 - Added logic for new RXEOB reversal file
#		: 01/28/2013 - Removed files for claim109gran process (DME)
#		: 07/12/2013 - Add claim109gran NCYP files
#		: 07/16/2013 - Add clmrt01 files for McKee (MF; 1041)
#		: 09/09/2013 - Add URX-Differential-<ccyymmdd>.zip
#		: 01/20/2015 - Remove CCAI/claim117 files (TT #12717-2)
#		: 01/20/2015 - Add "IB" clmrt files
#               : 02/02/2015 - Due to term of sys0052 and sys0071, remove rented network related procedures. (TT #12718-2, #12713-2).
#		: 01/12/2016 - Add ???CL16-SYS-INVTOT-P, remove PREFIX logic, and misc. other cleanup.
#		: 5/11/2016 - TT15163-5; claim109hcrm files
#		: 04/24/2017 - TT16776-3; removal of inactive McKee (MF) logic.
#		: 08/08/2017 - TT13915-53; removal of claim109eb and claim132 related files.
#               : 09/21/2018 - Removal of claim109d0 related files
#		: 05/29/2019 - TT13915-84; removal of claim123 files

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
RPTARCH="/usr/lnk/rptarch"
TAPE_DIR="/usr/lnk/tapes"
KEY_DIR="/usr/lnk/keys"
MISC_DIR="/usr/lnk/misc"
TMP_DIR="/usr/lnk/tmp"
WHSE_DIR="/usr/lnk/wt/sqlimports/claims"
XP_DIR="/usr/lnk/xp"
GRP_DIR="/usr/upd/grp"
GRP2_DIR="/usr/lnk/grp"
RPT_DIR="/usr/lnk/rpt"
CYCLE="pay"
ZIP_PROG="/usr/bin/zip"
RXEOB_DIR="/usr/lnk/rxeob"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-pay.sh [-d <p/e date(ccyymmdd)>]
	<p/e date> is the current period ending in ccyymmdd format

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


# REPORT FILES
zip_reports()
{
	cd ${PO_DIR}
	find sys???? -follow -name "SUSP.S??" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	find sys???? -follow -name "*CL1[6-7]?-[O,P]*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	mv reports-${DATE}.zip ${RPTARCH}/${CYCLE}/${CYCLE}-reports-${DATE}.zip
}

# XP FILES
zip_xp()
{
	cd ${XP_DIR}
	find sys0049 -follow -name "invb*" -print | ${ZIP_PROG} xp-${DATE}.zip -@
	mv xp-${DATE}.zip ${RPTARCH}/${CYCLE}/${CYCLE}-xp-${DATE}.zip
}

# MISC FILES
zip_misc()
{
	find ${MISC_DIR} -follow -name "???CL68-P*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "???PRINT-CL16-P" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "*CL16-SYS-INV-P" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "*CL16-SYS-INVTOT-P" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "pay-PRINT-CLAIM59-CYCLE-P" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
}

# TAPE FILES
zip_tapes()
{
	find ${TAPE_DIR} -follow -name "???CL111D0-P*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "???CL111RX-P-RXEOB" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "???-P-RXEOBTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "???CL130-P*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
}

# KEY FILES
zip_keys()
{
	find ${KEY_DIR} -follow -name "CLAIM68KEY-P*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM46KEY-P*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM47KEY-P*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM16KEY-P*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM111KEY-D0-P*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM111RXKEY-P*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM130KEY-P*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "REVER03KEY-P*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
}

# OTHER FILES
zip_other()
{
	find ${TMP_DIR} -follow -name "CLAIM01BAK.pay*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${WHSE_DIR} -follow -name "D0BIWKCLMS-${DATE}*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR} -follow -name "SUSPWRKMAS-P" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR} -follow -name "INLGWRKMAS-P" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP2_DIR} -follow -name "SYSTE00MAS" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${RXEOB_DIR} -follow -name "pdmi_reversals_cycle_p_${DATE}.txt" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
}

# RPT FILES
zip_rpt()
{
	find ${RPT_DIR} -follow -name "pay-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-rpt-${DATE}.zip -@
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

# Parse environment variables
#parse_env

date

zip_reports

zip_xp

zip_misc

zip_tapes

zip_keys

zip_other

zip_rpt

exit 0
