#!/bin/sh
#
# Program Name	: zip-week.sh
# Description	: Zipping week-cycle files to rptarch
#		  Command Line Arguments:
#		  -d <ccyymmdd> - p/e date
# Author	: Linda S. Jefferis
# Date		: 06/28/2005
# Modifications : 08/09/2005 - Added CLAIM106KEY-W  (LSJ)
#		: 04/29/2014 - added "TB","AX" clmrt files and ???TEMSTEXT file
#		: 07/08/2014 - add claim109hcrm related files
#		: 10/20/2014 - change "???EXMSTEXT" to "???TSCTEXT"
#		: 01/12/2016 - add ???CL16-SYS-INVTOT-W, remove PREFIX logic, and some other cleanup items.
#		: 03/21/2016 - TT15074-4 Add CLMRTTB files
#		: 12/22/2016 - TT16314-12 Add CLMRTRP files
#		: 02/12/2018 - Add CLMRTXM files
#		: 09/21/2018 - Removal of claim109d0 related files
#		: 11/04/2020 - Remove logic for claim111rx files
#               : 7/26/20922 - Task 45933 - remove claim109gran logic
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
XP_DIR="/usr/lnk/po/xp"
GRP_DIR="/usr/upd/grp"
GRP2_DIR="/usr/lnk/grp"
RPT_DIR="/usr/lnk/rpt"
CYCLE="week"
ZIP_PROG="/usr/bin/zip"
RXEOB_DIR="/usr/lnk/rxeob"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-week.sh [-d <p/e date(ccyymmdd)>] 
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
	find sys???? -follow -name "*CL1[6-7]?-W*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	mv reports-${DATE}.zip ${RPTARCH}/${CYCLE}/${CYCLE}-reports-${DATE}.zip
}


# MISC FILES
zip_misc()
{
	find ${MISC_DIR} -follow -name "???CL68-W" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "???PRINT-CL16-W" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "???CL16-SYS-INV-W" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "???CL16-SYS-INVTOT-W" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "wk-PRINT-CLAIM59-CYCLE-W" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
}

# TAPE FILES
zip_tapes()
{
	find ${TAPE_DIR} -follow -name "???CL111D0-W-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "???TEMSTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTAR" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
        find ${TAPE_DIR} -follow -name "????ARTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@	
	find ${TAPE_DIR} -follow -name "????CLMRTAX" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
        find ${TAPE_DIR} -follow -name "????AXTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@	
	find ${TAPE_DIR} -follow -name "????CLMRTBA" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
        find ${TAPE_DIR} -follow -name "????BATEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@	
	find ${TAPE_DIR} -follow -name "????CLMRT2P" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
        find ${TAPE_DIR} -follow -name "????2PTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@	
	find ${TAPE_DIR} -follow -name "????CLMRTTB" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
        find ${TAPE_DIR} -follow -name "????TBTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@	
	find ${TAPE_DIR} -follow -name "????CLMRTRP" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
        find ${TAPE_DIR} -follow -name "????RPTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@	
	find ${TAPE_DIR} -follow -name "????CLMRTXM" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
        find ${TAPE_DIR} -follow -name "????XMTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@	
}

# KEY FILES
zip_keys()
{
	find ${KEY_DIR} -follow -name "CLAIM68KEY-W*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM46KEY-W*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM47KEY-W*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM16KEY-W*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "REVER03KEY-W*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM55KEY-W*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM111RXKEY-W*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM111KEY-D0-W*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLMRT01KEY-W*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
}

# OTHER FILES
zip_other()
{
	find ${TMP_DIR} -follow -name "CLAIM01BAK.week*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${WHSE_DIR} -follow -name "D0WEEKCLMS-${DATE}*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR} -follow -name "INLGWRKMAS-W" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR} -follow -name "SUSPWRKMAS-W" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP2_DIR} -follow -name "SYSTE00MAS" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
}

# RPT FILES
zip_rpt()
{
	find ${RPT_DIR} -follow -name "week-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-rpt-${DATE}.zip -@
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

zip_misc

zip_tapes

zip_keys

zip_other

zip_rpt

echo ""
echo "List of created archive zip files"
ls -l ${RPTARCH}/week/week-*-${DATE}.zip

exit 0
