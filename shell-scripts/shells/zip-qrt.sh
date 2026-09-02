#!/bin/ksh
#
# Program Name	: zip-qrt.sh
# Description	: Zipping qrt-cycle files to rptarch
#		  Command Line Arguments:
#		  -d <ccyymmdd> - q/e date
#                 -p <q/e prefix> (e.g. I30)
# Author	: Linda S. Jefferis
# Date		: 10/14/1999
# Modifications : 11/15/2000 - Changes for new version of pkzip  (LSJ)
#		: 01/14/2002 - Added ${ZIP_PROG} and ${CYCLE} prefix on zip filenames  (LSJ)
#		: 05/01/2002 - Added TEMP_DIR and associated logic  (LSJ)
#		: 01/16/2004 - Addition of Claim122 data file and rpt files (LSJ)
#		: 10/19/2004 - Addition of rebate15 files  (LSJ)
#		: 10/28/2005 - Changes for Linux  (LSJ)
#		: 07/10/2006 - Removed claim122 related references  (LSJ)
#		: 10/25/2006 - Changes for 4-digit system numbers  (LSJ)
#		: 05/15/2007 - Addition of claim109en files  (LSJ)
#		: 10/11/2007 - name change to ENNI-Q-TEXT  (LSJ)
#		: 02/21/2008 - Removed files related to claim109en; Ennis terminated so this process is no longer run  (LSJ)
#		: 01/15/2009 - Added RE02 files  (LSJ)
#		: 01/13/2011 - Changed input date format and other miscellaneous cleanup
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
CLMS_DIR="/usr/lnk/claims"
RB_DIR="/usr/lnk/wt/sqlimports/misc"
RPT_DIR="/usr/lnk/rpt"
TAPE_DIR="/usr/lnk/tapes"
CYCLE="qrt"
PREFIX="null"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-qrt.sh [-d <q/e date(ccyymmdd)>] [-p <q/e prefix>]

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
	find sys???? -name "${PREFIX}CL29*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	find sys???? -name "${PREFIX}CL33*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	find sys???? -name "*CL19*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	find sys???? -name "*RE02*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	mv reports-${DATE}.zip ${RPTARCH}/${CYCLE}/${CYCLE}-reports-${DATE}.zip
}

# MISC FILES
zip_misc()
{
	find ${MISC_DIR} -name "CLAIM114-RPT.*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-misc-${DATE}.zip -@
}

# KEY FILES
zip_keys()
{
	find ${KEY_DIR} -follow -name "CLAIM29KEY*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
	find ${KEY_DIR} -follow -name "CLAIM114KEY*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-keys-${DATE}.zip -@
}

# OTHER FILES
zip_other()
{
	${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip ${RB_DIR}/CLAIM29RB001-${DATE}.gz
	${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip ${CLMS_DIR}/CLAIM33MAS*
}

# RPT FILES
zip_rpt()
{
        find ${RPT_DIR} -follow -name "qrt-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-rpt-${DATE}.zip -@
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
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        PREFIX=$1
        ;;
  esac
  shift
done

# Parse environment variables
#parse_env

if [ ${PREFIX} = "null" ]
then
   usage
fi


zip_reports

zip_misc

zip_keys

zip_other

zip_rpt

exit 0
