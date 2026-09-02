#!/bin/ksh
#
# Program Name	: zip-week-ault.sh
# Description	: Zipping week-ault files to rptarch
#		  Command Line Arguments:
#		  -d <mmddyy> - p/e date
# Author	: Linda S. Jefferis
# Date		: 09/29/2005
# Modifications : 10/28/2005 - Changes for Linux  (LSJ)
#		: 12/03/2005 - Changes for new system names  (LSJ)
#		: 09/15/2006 - Added AULTEXT file and removed MEDITEXT  (LSJ)
#		: 11/24/2006 - Added logic back in for MEDI files  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
TEMP_DIR="/usr/lnk/sort"
RPTARCH="/usr/lnk/rptarch/week"
TAPE_DIR="/usr/lnk/tapes"
KEY_DIR="/usr/lnk/keys"
MISC_DIR="/usr/lnk/po/misc"
RPT_DIR="/usr/lnk/rpt"
MISC="misc"
CYCLE="week-ault"
REMOTE_SYS="husk"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-week-ault.sh [-d <w/e date(mmddyy)>]
	<w/e date> is the week ending in mmddyy format

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

cd ${MISC_DIR}
zip -j ${TAPE_DIR}/${CYCLE}-${DATE}.zip tweek-PRINT-CLAIM59-CYCLE-TW
cd ${KEY_DIR}
zip -j ${TAPE_DIR}/${CYCLE}-${DATE}.zip CLAIM113KEY
cd ${RPT_DIR}
zip -j ${TAPE_DIR}/${CYCLE}-${DATE}.zip claim59 twice-claim113 twice-tr-cl113
cd ${TAPE_DIR}
zip ${CYCLE}-${DATE}.zip -m ???-T-AHFTEXT ???-T-CASTEXT ???-T-AULTEXT ???-T-MEDITEXT ???CL113-T-*

scp ${TAPE_DIR}/${CYCLE}-${DATE}.zip ${REMOTE_SYS}:${RPTARCH}

exit 0
