#!/bin/sh
#
# Program Name	: zip-twice.sh
# Description	: Zipping twice-cycle files to rptarch
#		  Command Line Arguments:
#		  -d <mmddyy> - p/e date
# Author	: Linda S. Jefferis
# Date		: 12/30/2004
# Modifications : 02/03/2005 - Addition of PRINT-CLAIM59-CYCLE-T  (LSJ)
#		: 02/03/2005 - Addition of claim130 and claim111 files  (LSJ)
#		: 03/02/2005 - Change claim111 files to claim178 files  (LSJ)
#		: 05/17/2005 - Changes for new "-T" suffix for KEY files  (LSJ)
#		: 06/17/2005 - Added claim111 RXEOB files  (LSJ)
#		: 09/27/2005 - Addition of files for limit48 and claim44 (LSJ)
#		: 10/07/2005 - Additions for clmrt01  (LSJ)
#		: 10/28/2005 - Changes for Linux  (LSJ)
#		: 11/02/2005 - Added ???-T-X12-ERR  (LSJ)
#		: 01/12/2006 - Addition of SYSTE00MAS  (LSJ)
#		: 03/09/2006 - Addition of claim109 files  (LSJ)
#		: 10/18/2006 - Addition of JJHC files  (LSJ)
#		: 05/22/2007 - Changed CL44 filename to ???CL44-*-T  (LSJ)
#		: 06/04/2007 - Added claim130 AHF files  (LSJ)
#		: 07/02/2007 - Added claim109 AHF file  (LSJ)
#		: 01/04/2008 - Added tape and key files for claim111rx  (LSJ)
#		: 03/27/2008 - Added ????CL58-T
#		: 06/02/2008 - Added claim111 file for JHS  (LSJ)
#		: 03/17/2009 - Added claim109qtm files  (LSJ)
#		: 04/02/2009 - Removed limit48 and claim12 files  (LSJ)
#		: 06/03/2009 - Added "date" display  (LSJ)
#		: 09/18/2009 - Changes for switch to new check run process
#		: 02/02/2010 - Added "OH" tapes files  (LSJ)
#		: 07/02/2010 - Added "?" to RXEOB file names  (LSJ)
#		: 11/18/2010 - Changes for AHF switch to tweek-cycle
#		: 01/12/2011 - Changed input date format and other miscellaneous changes
#		: 09/01/2011 - Added "D0" prefix to BIMOCLMS file name
#		: 11/07/2011 - Added CL111D0 files for dual runs
#		: 11/29/2022 - Added "BE" files
#		: 09/24/2012 - Added RXEOB reversal file logic
#		: 01/22/2013 - Added claim111rx files
#		: 01/23/2013 - Added CLMRTTL files
#		: 02/20/2013 - Added EBA files
#		: 11/19/2013 - Added claim130 files
#		: 04/15/2014 - Add LVHN clmrt01 files
#		: 1/1/2015 - ODMH terminated
#		: 01/19/2015 - Added CLMRTCF files (TT #12337-11)
#		: 05/12/2015 - Added claim109d0 file (TT:13528-1)
#		: 08/24/2015 - TT:13604-27; add CLMRTHM files
#		: 01/12/2016 - add ???CL16-SYS-INVTOT-T
#		: 06/02/2016 - TT15075-5 remove sys0102 (BE) related files.
#		: 02/08/2017 - TT16831-5; logic for CLMRTHR (sys0181) files.
#		: 07/26/2017 - TT17250-2; logic for CLMRTCN (sys0183) files.
#		: 07/31/2018 - TT13915-66; RXFL files
#		: 02/07/2019 - Add clmrt01 "DM" and "FV" files
#		: 02/18/2019 - TT18858-47; add logic for claim109gran
#		: 02/18/2019 - Remove logic for claim109d0, EBA, and non-active CLMRT files.
#		: 05/19/2020 - TT20251-11; APRXMBEN clmrt01 files
#		: 08/03/2020 - TT20686-1; PSI ("PS") clmrt01 files
#		: 11/06/2020 - TT20826-1; AME ("me") clmrt01 files
#		: 11/06/2020 - TT20930-2; HWF ("hw") clmrt01 files
#		: 09/09/2021 - APO ("ap"), HPS ("cs"), and BPS files (bl,bc,bo,bn)
#		: 10/04/2021 - BPSCPS ("bx") clmrt01 files
#		: 01/10/2023 - New 2023 clmrt01 files: PAYSN, HWFD, FVFNDP
#		: 02/23/2023 - New BLRX clmrt01 files
#		: 08/29/2023 - Add EVOTEXT files
#		: 03/18/2024 - Add new Eversana ("EV") clmrt01 files
#		: 02/17/2025 - Removed claim130/claim109gran associated files
#
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
CLMS_DIR="/usr/upd/claims"
XP_DIR="/usr/lnk/xp"
GRP_DIR="/usr/upd/grp"
GRP2_DIR="/usr/lnk/grp"
RPT_DIR="/usr/lnk/rpt"
RXEOB_DIR="/usr/lnk/rxeob"
CYCLE="twice"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-twice.sh [-d <p/e date(ccyymmdd)>] 
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
	find sys???? -follow -name "*CL1[6-7]?-T*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	mv reports-${DATE}.zip ${RPTARCH}/${CYCLE}/${CYCLE}-reports-${DATE}.zip
}

# XP FILES
zip_xp()
{
	cd ${XP_DIR}
	find sys???? -follow -name "inv-t-*" -print | ${ZIP_PROG} xp-${DATE}.zip -@
	mv xp-${DATE}.zip ${RPTARCH}/${CYCLE}/${CYCLE}-xp-${DATE}.zip
}

# MISC FILES
zip_misc()
{
	find ${MISC_DIR} -follow -name "???CL68-T" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "???PRINT-CL16-T" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "???CL16-SYS-INV-T" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "???CL16-SYS-INVTOT-T" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "twice-PRINT-CLAIM59-CYCLE-T" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
}

# TAPE FILES
zip_tapes()
{
	find ${TAPE_DIR} -follow -name "????CLMRTTRCD" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTTL" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????TRCDTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????TLTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTOH" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????OHTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTWSN" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????WSNTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTCF" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CFTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTHM" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????HMTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTCN" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CNTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTRXFL" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????RXFLTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTDM" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????DMTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTFV" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????FVTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTRM" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????RMTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTPS" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????PSTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTME" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????METEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTHW" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????HWTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTCS" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CSTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTAP" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????APTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTBL" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????BLTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTBC" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????BCTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTBO" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????BOTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTBN" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????BNTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTBX" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????BXTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTVS" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????VSTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTGX" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????GXTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTPN" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????PNTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTBK" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????BKTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTWD" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????WDTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTFC" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????FCTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTEV" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????EVTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "???CL111*-T-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "???CL111RX-T-RXEOB" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "???-T-RXEOBTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
}

# KEY FILES
zip_keys()
{
	find ${KEY_DIR} -follow -name "CLAIM68KEY-T*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM46KEY-T*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM47KEY-T*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM16KEY-T*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "REVER03KEY-T*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM55KEY-T*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLMRT01KEY-T*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM111KEY*-T*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM111RXKEY-T" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
}

# OTHER FILES
zip_other()
{
	find ${TMP_DIR} -follow -name "CLAIM01BAK.twice*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${WHSE_DIR} -follow -name "D0BIMOCLMS-${DATE}*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR} -follow -name "INLGWRKMAS-T" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR} -follow -name "SUSPWRKMAS-T" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP2_DIR} -follow -name "SYSTE00MAS" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${RXEOB_DIR} -follow -name "pdmi_reversals_cycle_t_${DATE}.txt" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
}

# RPT FILES
zip_rpt()
{
	find ${RPT_DIR} -follow -name "twice-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-rpt-${DATE}.zip -@
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
