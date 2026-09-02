#!/bin/sh
#
# Program Name	: pmsi_elig_files.sh
# Description	: Procedure to transfer eligibility error report to PMSI (sys0103)
#		  Command Line Arguments:
#		  -d  Set alternate date for filenames <yymmddhhmmss>
#		  -t  Test send flag
# Author	: Linda S. Jefferis
# Date		: 07/06/2007
# Modifications : 03/24/2008 - Added logic for ACCUM_RPT file
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
FILE_LOC="/usr/lnk/misc"
ARCH_DIR="/usr/lnk/elig_in_1/sys0103"
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
ERROR_RPT="PMSI-0103-????????"
ACCUM_RPT="ACC01_0103_??????????????.csv"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
TR_ID="PMSI-ELIG"
DATE=`date +%y%m%d%H%M%S`
TEST=0
SEND_TYPE="prod"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pmsi_elig_files.sh 

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
# Set filenames
set_filenames()
{
	NEW_ERR_RPT="elig_${SEND_TYPE}_loadrpt_${DATE}.dat"
	NEW_ACCUM_RPT="elig_${SEND_TYPE}_accumrpt_${DATE}.csv"
}

#
rename_files()
{
	if test -s ${FILE_LOC}/${ERROR_RPT}
	then
	  scp ${FILE_LOC}/${ERROR_RPT} ${REMOTE_SYS}:${REMOTE_DIR}/${NEW_ERR_RPT}
	  mv ${FILE_LOC}/${ERROR_RPT} ${ARCH_DIR}
	else
	  echo "-*> Eligibility Error Report file does not exist..."
	  exit 1
	fi
	ssh -q ${REMOTE_SYS} "mv ${REMOTE_DIR}/${ACCUM_RPT} ${REMOTE_DIR}/${NEW_ACCUM_RPT}"
}


# Cleanup
clean_up()
{
	ssh -q ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${NEW_ERR_RPT}"
	ssh -q ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${NEW_ACCUM_RPT}"
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
#if [ $# -lt 2 ]
#then
#   usage
#   exit 2
#fi

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
    -t) TEST=1
	SEND_TYPE="test"
	TR_ID="PMSI-ELIG-TST"
	;;
  esac
  shift
done

# Parse environment variables
#parse_env

set_filenames

echo
echo "--> Renaming file..."
echo

rename_files

echo 
echo "--> Transferring file to ${TR_ID}..."
echo
ssh -q ${REMOTE_SYS} "${TR_PROG} ${TR_ID} ${REMOTE_DIR}/${NEW_ERR_RPT} ${REMOTE_DIR}/${NEW_ACCUM_RPT}"

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
