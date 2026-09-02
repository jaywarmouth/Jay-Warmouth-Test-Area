#!/bin/ksh
#
# Program Name	: zip-tweek.sh
# Description	: Zipping tweek-cycle files to rptarch
#		  Command Line Arguments:
#		  -d <mmddyy> - p/e date
# Author	: Linda S. Jefferis
# Date		: 10/19/2010
# Modifications : 01/12/2011 - Input date format and other miscellaneous changes
#		: 07/18/2011 - Add claim83ghc files
#		: 09/01/2011 - Added "D0" prefix to MIDBIMOCLMS file name
#		: 06/11/2012 - Add pdmi_reversals file for RXOB
#		: 07/29/2013 - Added claim111d0 files
#		: 01/12/2016 - add ???CL16-SYS-INVTOT-X
#		: 06/02/2016 - TT15075-5 remove AEBS files
#		: 06/20/2016 - TT15288-48 (PAF and clmrt01 iles)
#               : 1/9/2018 - TT17821-4; removal of PRAT related files.
#		: 4/5/2018 - TT18486-54; changes for AHF terminations.
#		: 6/25/2018 - TT13915-64; removal of rentnet files
#		: 07/06/2018 - TT18645-20; add LLS (sys0185) files
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
XP_DIR="/usr/lnk/xp"
GRP_DIR="/usr/upd/grp"
GRP2_DIR="/usr/lnk/grp"
RPT_DIR="/usr/lnk/rpt"
RXEOB_DIR="/usr/lnk/rxeob"
CYCLE="tweek"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-tweek.sh [-d <p/e date(ccyymmdd)>]
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
	find sys???? -follow -name "*CL1[6-7]?-X*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	mv reports-${DATE}.zip ${RPTARCH}/${CYCLE}/${CYCLE}-reports-${DATE}.zip
}

# XP FILES
zip_xp()
{
	cd ${XP_DIR}
	find sys???? -follow -name "inv-x-*" -print | ${ZIP_PROG} xp-${DATE}.zip -@
	mv xp-${DATE}.zip ${RPTARCH}/${CYCLE}/${CYCLE}-xp-${DATE}.zip
}

# MISC FILES
zip_misc()
{
	find ${MISC_DIR} -follow -name "???CL68-X" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "*PRINT-CL16-X" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "*CL16-SYS-INV-X" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "*CL16-SYS-INVTOT-X" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "tweek-PRINT-CLAIM59-CYCLE-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
}

# TAPE FILES
zip_tapes()
{
	find ${TAPE_DIR} -follow -name "???CL113-X-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "AULTCARE-ACT-GENERIC-TABLES.txt" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "???CL111D0*-X-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTPA" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
        find ${TAPE_DIR} -follow -name "????PATEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTLL" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
        find ${TAPE_DIR} -follow -name "????LLTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTFB" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
        find ${TAPE_DIR} -follow -name "????FBTEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
	find ${TAPE_DIR} -follow -name "????CLMRTCI" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
        find ${TAPE_DIR} -follow -name "????CITEXT" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-tapes-${DATE}.zip -@
}

# KEY FILES
zip_keys()
{
	find ${KEY_DIR} -follow -name "CLAIM68KEY-X*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM46KEY-X*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM47KEY-X*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM16KEY-X*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "REVER03KEY-X*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM55KEY-X*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM111KEY-D0-X*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM113KEY*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLMRT01KEY-X" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
}

# OTHER FILES
zip_other()
{
	find ${TMP_DIR} -follow -name "CLAIM01BAK.tweek*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${WHSE_DIR} -follow -name "D0MIDBIMOCLMS-${DATE}*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR} -follow -name "INLGWRKMAS-X" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR} -follow -name "SUSPWRKMAS-X" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
	find ${GRP2_DIR} -follow -name "SYSTE00MAS" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip -@
}

# RPT FILES
zip_rpt()
{
	find ${RPT_DIR} -follow -name "tweek-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-rpt-${DATE}.zip -@
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

echo ""
echo "List of created archive zip files"
ls -l ${RPTARCH}/tweek/tweek-*-${DATE}.zip

exit 0
