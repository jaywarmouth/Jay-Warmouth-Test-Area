#!/bin/sh
#
# Program Name	: zip-chk.sh
# Description	: Zipping check run files to rptarch
#		  Command Line Arguments:
#		  -d <ccyymmdd> - p/e date
# Author	: Linda S. Jefferis
# Date		: 09/18/2009
# Modifications : 06/04/2010 - Added nacha01 files
#		: 06/08/2010 - Added EFT0000WRK-ccyymmdd file
#		: 07/15/2010 - Added CL07Z-E report
#		: 07/16/2010 - Added CL28Z-E report
#		: 01/13/2011 - Changed format of date input
#		: 10/26/2011 - Added V5010 files
#		: 10/21/2014 - Add KeyBank check outsource files (6939-2)
#		: 01/01/2018 - TT:13915-59
#		: TT13915-64 - Removal of claim70 related files
#		: 7/21/2022 - enhancement updates
#		: 07/28/2022 - added missed WT_DIR variable setting
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
CLMS_DIR="/usr/upd/claims"
GRP_DIR="/usr/upd/grp"
GRP_DIR2="/usr/lnk/grp"
RPT_DIR="/usr/lnk/rpt"
WT_DIR="/usr/lnk/wt/pdm/chkrun"
CYCLE="chk"
ZIP_PROG="/usr/bin/zip"
financewt="/usr/lnk/wt/finance"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-chk.sh [-d <p/e date(ccyymmdd)>] [-p <p/e prefix>]

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
	find . -follow -name "*CL07?-C*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	find . -follow -name "*CL07?-E*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	find . -follow -name "*CL20?-C*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	find . -follow -name "*CL37?-C*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	find . -follow -name "*CL37?-C*" -print | ${ZIP_PROG} financeCL37-${DATE}.zip -@
	find . -follow -name "*-CHK-REGISTER*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	mv reports-${DATE}.zip ${RPTARCH}/${CYCLE}/${CYCLE}-reports-${DATE}.zip
	mv financeCL37-${DATE}.zip ${financewt}
}

# MISC FILES
zip_misc()
{
	find ${MISC_DIR} -follow -name "*CL88-C*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "CL??-C-TOTALS*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "CL127-C-TOTALS*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "???CL07-C-ZEROCHK" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "???-*-X12-ERR" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "???-*-X12-IR-ERR" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "????CL58-C" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "SYS-CHK-TOTALS" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "PRINT-SUSP002" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "NACHA01-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "KEYCARDERR-C.txt" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
}

# TAPE FILES
zip_tapes()
{
	find ${TAPE_DIR} -follow -name "???????-V5010" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "???????-V5010-LINE" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "???????-V5010-TEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "???NHIN-V5010" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "NACHA-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "KEY*.arm.kbarm" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
}

# KEY FILES
zip_keys()
{
	find ${KEY_DIR} -follow -name "CLAIM45KEY*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM88KEY*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM20KEY*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "RECONX12KEY*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM37KEY*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM07KEY*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLM07TOTKEY*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
}

# OTHER FILES
zip_other()
{
	find ${TMP_DIR} -follow -name "CLWRK00MAS.chk" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${TMP_DIR} -follow -name "CLWRK00MAS.chk.${DATE}*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${CLMS_DIR} -follow -name "CHKWRK-C" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR} -follow -name "INLGWRKMAS-C" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR2} -follow -name "SYSTE00MAS" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR} -follow -name "TRIGGERMAS" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${TMP_DIR} -follow -name "EFT0000WRK-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${WT_DIR} -follow -name "chkrun-CL20.txt" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${WT_DIR} -follow -name "chkwrk-*.txt" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
}

# RPT FILES
zip_rpt()
{
	find ${RPT_DIR} -follow -name "chk-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-rpt-${DATE}.zip -@
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

umask 002

zip_reports

zip_misc

zip_tapes

zip_keys

zip_other

zip_rpt

echo "List of zip files:" 
ls -l ${RPTARCH}/${CYCLE}/${CYCLE}-*-${DATE}.zip

exit 0
