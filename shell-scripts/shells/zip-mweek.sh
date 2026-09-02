#!/bin/ksh
#
# Program Name	: zip-mweek.sh
# Description	: Zipping MEDD week-cycle files to rptarch
#		  Command Line Arguments:
#		  -d <mmddyy> - p/e date
# Author	: Linda S. Jefferis
# Date		: 12/29/2009
# Modifications : 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
RPTARCH="/usr/lnk/rptarch"
KEY_DIR="/usr/lnk/keys"
MISC_DIR="/usr/lnk/misc"
TMP_DIR="/usr/lnk/tmp"
WHSE_DIR="/usr/lnk/wh"
GRP_DIR="/usr/upd/grp"
RPT_DIR="/usr/lnk/rpt"
CYCLE="mweek"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-mweek.sh [-d <p/e date(mmddyy)>]
	<p/e date> is the current period ending in mmddyy format

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
	find sys0048 -follow -name "*CL1[6-7]?-T*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	mv reports-${DATE}.zip ${RPTARCH}/week/${CYCLE}-reports-${DATE}.zip
}


# MISC FILES
zip_misc()
{
	cd ${RPTARCH}
	find ${MISC_DIR} -follow -name "???PRINT-CL16-T" -print | ${ZIP_PROG} -j ${CYCLE}-misc-${DATE}.zip -@
	find ${MISC_DIR} -follow -name "???CL16-SYS-INV-T" -print | ${ZIP_PROG} -j ${CYCLE}-misc-${DATE}.zip -@
	mv ${CYCLE}-misc-${DATE}.zip ${RPTARCH}/week
}


# KEY FILES
zip_keys()
{
	cd ${RPTARCH}
	find ${KEY_DIR} -follow -name "CLAIM16KEY-X*" -print | ${ZIP_PROG} -j ${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM55KEY-X*" -print | ${ZIP_PROG} -j ${CYCLE}-keys-${DATE}.zip -@
	mv ${CYCLE}-keys-${DATE}.zip ${RPTARCH}/week
}

# OTHER FILES
zip_other()
{
	cd ${RPTARCH}
	find ${TMP_DIR} -follow -name "CLAIM01BAK.mweek*" -print | ${ZIP_PROG} -j ${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR} -follow -name "INLGWRKMAS-X" -print | ${ZIP_PROG} -j ${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR} -follow -name "SUSPWRKMAS-X" -print | ${ZIP_PROG} -j ${CYCLE}-files-${DATE}.zip -@
	find ${GRP_DIR} -follow -name "SYSTE00MAS" -print | ${ZIP_PROG} -j ${CYCLE}-files-${DATE}.zip -@
	mv ${CYCLE}-files-${DATE}.zip ${RPTARCH}/week
}

# RPT FILES
zip_rpt()
{
	cd ${RPTARCH}
	find ${RPT_DIR} -follow -name "mweek-*" -print | ${ZIP_PROG} -j ${CYCLE}-rpt-${DATE}.zip -@
	mv ${CYCLE}-rpt-${DATE}.zip ${RPTARCH}/week
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

zip_keys

zip_other

zip_rpt

exit 0
