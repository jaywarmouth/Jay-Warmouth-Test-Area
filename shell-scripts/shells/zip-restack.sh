#!/bin/ksh
#
# Program Name	: zip-restack.sh
# Description	: Zipping restack files to rptarch
#		  Command Line Arguments:
#		  -d <ccyymmdd> - restack date
# Author	: Linda S. Jefferis
# Date		: 04/17/2013
# Modifications	: 10/02/2014 - Change AUDIT-401 to AUDIT-400
#		: 01/22/2015 - Adding ProductionRestack<date>.pdf and RSTK-DRGSPNT-* to zip process. Also add variable for current Date for run. (TT:4805-10) (DME)
#		: 07/20/2016 - TT12432-4; change to AUDIT-404
#
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
RPTARCH="/usr/lnk/rptarch"
TMP_DIR="/usr/lnk/shares/ftp-tmp/restack"
AUD_DIR="/usr/lnk/audit"
RPT_DIR="/usr/lnk/rpt"
RST_DIR="/usr/lnk/restack"
CYCLE="restack"
PREFIX="null"
ZIP_PROG="/usr/bin/zip"
DATE=`date +"%Y%m%d"`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-restack.sh -d <ccyymmdd>
	-d <ccyymmdd>	restack date

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



# MISC FILES
zip_other()
{
	${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip ${TMP_DIR}/restack*
	${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip ${TMP_DIR}/RESTACK*
	${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip ${RST_DIR}/*RST
	${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip ${TMP_DIR}/CLMRS-*
	${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip ${TMP_DIR}/CLWRK-*
        ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip ${TMP_DIR}/RSTK*
        ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip ${TMP_DIR}/ProductionRestack*
	${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-files-${DATE}.zip ${AUD_DIR}/AUDIT-404-${DATE}.prod10
}


# RPT FILES
zip_rpt()
{
        find ${RPT_DIR} -follow -name "rst-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-rpt-${DATE}.zip -@
        find ${TMP_DIR} -follow -name "rst-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-rpt-${DATE}.zip -@
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


zip_other
zip_rpt

exit 0
