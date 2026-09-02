#!/bin/ksh
#
# Program Name	: backup-calmon.sh
# Description	: Backup calendar month-end files to tape
# Author	: Linda S. Jefferis
# Date		: 03/12/99
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
TAPE="c0t4d0s0"
PO_DIR="/usr/lnk/po"
TAPE_DIR="/usr/lnk/tapes"
KEY_DIR="/usr/lnk/keys"
TMP_DIR="/usr/lnk/tmp"
CLAIM_DIR="/usr/lnk/claims"
MED_DIR="/usr/lnk/medispan"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: backup-calmon.sh 

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

# Parse environment variables
parse_env

cd ${PO_DIR}

date

find . -follow -name "*CL34*" -print > ${PO_DIR}/cpio-mon
find /usr/pdm/rebate -follow -name "reb*" -print >> ${PO_DIR}/cpio-mon
find /usr/lnk/crd_01 -follow -name "CARDH80MAS.34" -print >> ${PO_DIR}/cpio-mon
find ${KEY_DIR} -follow -name "CLAIM34KEY.sys??" -print >> ${PO_DIR}/cpio-mon
timex cpio -ocvBL < ${PO_DIR}/cpio-mon > /dev/rmt/${TAPE}
rm ${PO_DIR}/cpio-mon

exit 0
