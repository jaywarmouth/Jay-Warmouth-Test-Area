#!/bin/sh
#
# Program Name	: pmsi_pharm_files.sh
# Description	: Procedure to setup pharmacy files for PMSI (sys0103)
#		  Command Line Arguments:
#		  -d  Set alternate date for filenames <yymmddhhmmss>
#		  -t  Test send flag
# Author	: Linda S. Jefferis
# Date		: 03/11/2008
# Modifications : 03/20/2008 - modifications to work with ncpdppmsi.sh  (LSJ)
#		: 03/21/2008 - added different TR_ID for TEST run  (LSJ)
#		: 03/28/2008 - changed logic to access Husk remotely  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PHARM_RPT="PMSIREPORT"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
TR_ID="PMSI-PHARM"
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
DATE=`date +%y%m%d%H%M%S`
TEST=0
SEND_TYPE="prod"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pmsi_pharm_files.sh 

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
	NEW_PHA_RPT="phnetw_${SEND_TYPE}_loadrpt_${DATE}_load.txt"
}

#
rename_files()
{
	ssh -q ${REMOTE_SYS} "mv ${REMOTE_DIR}/${PHARM_RPT} ${REMOTE_DIR}/${NEW_PHA_RPT}"
}


# Cleanup
clean_up()
{
	ssh -q ${REMOTE_SYS} "${CLEANUP_SCRIPT} -f ${REMOTE_DIR}/${NEW_PHA_RPT}"
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
	TR_ID="PMSI-PHARM-TST"
	;;
  esac
  shift
done

# Parse environment variables
#parse_env

set_filenames

echo
echo "--> Converting file..."
echo

rename_files

echo 
echo "--> Transferring file to ${TR_ID}..."
echo
ssh -q ${REMOTE_SYS} "${TR_PROG} ${TR_ID} ${REMOTE_DIR}/${NEW_PHA_RPT}"

echo
echo "--> Cleaning up..."
echo

clean_up

echo "-=> Finished."

exit 0
