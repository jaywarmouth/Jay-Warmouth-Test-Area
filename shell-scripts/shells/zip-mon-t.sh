#!/bin/ksh
#
# Program Name	: zip-mon-t.sh
# Description	: Zipping mon-cycle files to rptarch
#		  Command Line Arguments:
#		  -d <mmddyy> - m/e date
#                 -p <m/e prefix> (e.g. E30)
#		  -s <####> switch settings for each zipping section:
#			(reports,keys,misc,rpt-files)
# Author	: Linda S. Jefferis
# Date		: 02/08/2005
# Modifications : 10/28/2005 - Changes for Linux  (LSJ)
#		: 09/28/2006 - Added "-follow" to find sys?? command  (LSJ)
#		: 09/28/2006 - Changed sys?? to sys????  (LSJ)
#		: 11/06/2006 - Cleanup of unused logic  (LSJ)
#		: 07/06/2007 - More cleanup of unused logic  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
TEMP_DIR="/usr/lnk/sort"
PO_DIR="/usr/lnk/po"
RPTARCH="/usr/lnk/rptarch"
TAPE_DIR="/usr/lnk/tapes"
KEY_DIR="/usr/lnk/keys"
MISC_DIR="/usr/lnk/po/misc"
TMP_DIR="/usr/lnk/tmp"
CLMS_DIR="/usr/lnk/claims"
CRD_DIR="/usr/lnk/crd_01"
RPT_DIR="/usr/lnk/rpt"
MISC="misc"
CYCLE="mon"
PREFIX="null"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-mon-t.sh [-d <m/e date(mmddyy)>] [-p <m/e prefix>] [-s <######>]

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

# Separate switches
split_sw()
{
    SW1=`echo ${SW} | cut -c1`
    SW2=`echo ${SW} | cut -c2`
    SW3=`echo ${SW} | cut -c3`
    SW4=`echo ${SW} | cut -c4`
    SW5=`echo ${SW} | cut -c5`
    SW6=`echo ${SW} | cut -c6`
}


# REPORT FILES
zip_reports()
{
	cd ${PO_DIR}
	find sys???? -follow -name "${PREFIX}CL39?-T*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	find sys???? -follow -name "${PREFIX}CL57?-T*" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	find sys???? -follow -name "${PREFIX}LTRINV" -print | ${ZIP_PROG} reports-${DATE}.zip -@
	mv reports-${DATE}.zip ${RPTARCH}/${CYCLE}/${CYCLE}-t-reports-${DATE}.zip
}


# KEY FILES
zip_keys()
{
	cd ${TEMP_DIR}
	find ${KEY_DIR} -follow -name "CLAIM56KEY-T" -print | ${ZIP_PROG} -j ${CYCLE}-t-keys-${DATE}.zip -@
	mv ${CYCLE}-t-keys-${DATE}.zip ${RPTARCH}/${CYCLE}
}

# MISC FILES
zip_misc()
{
	cd ${TEMP_DIR}
        find ${MISC_DIR} -follow -name "${PREFIX}LIMINVFILE-T" -print | ${ZIP_PROG} -j ${CYCLE}-t-misc-${DATE}.zip -@
	mv ${CYCLE}-t-misc-${DATE}.zip ${RPTARCH}/${CYCLE}
}


# RPT FILES
zip_rpt()
{
        cd ${TEMP_DIR}
        find ${RPT_DIR} -follow -name "mon-t-*" -print | ${ZIP_PROG} -j ${CYCLE}-t-rpt-${DATE}.zip -@
        mv ${CYCLE}-t-rpt-${DATE}.zip ${RPTARCH}/${CYCLE}
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
    -s) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	SW=$1
        split_sw
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


if [ ${SW1} = 1 ]
then
  zip_reports
fi

if [ ${SW2} = 1 ]
then
  zip_keys
fi

if [ ${SW3} = 1 ]
then
  zip_misc
fi

if [ ${SW4} = 1 ]
then
  zip_rpt
fi

exit 0
