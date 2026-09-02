#!/bin/ksh
#
# Program Name	: backup-pay.sh
# Description	: Backup pay-cycle files to tape
# Author	: Linda S. Jefferis
# Date		: 09/25/98
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

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: backup-pay.sh 

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

cp /usr/raven/tapes/???CL72MMRX* ${TAPE_DIR}
find . -follow -name "*CL05*" -print > ${PO_DIR}/cpio-off
find . -follow -name "*CL06*" -print >> ${PO_DIR}/cpio-off
find . -follow -name "*CL30*" -print >> ${PO_DIR}/cpio-off
find . -follow -name "*CL28*" -print >> ${PO_DIR}/cpio-off
find . -follow -name "*CL20*" -print >> ${PO_DIR}/cpio-off
find . -follow -name "*CL07*" -print >> ${PO_DIR}/cpio-off
find . -follow -name "*CL37*" -print >> ${PO_DIR}/cpio-off
find . -follow -name "*CLRMB*" -print >> ${PO_DIR}/cpio-off
find ./misc -follow -name "*" -print >> ${PO_DIR}/cpio-off
find ${TAPE_DIR} -follow -name "*" -print >> ${PO_DIR}/cpio-off
find ${KEY_DIR} -follow -name "*" -print >> ${PO_DIR}/cpio-off
find ${TMP_DIR} -follow -name "CLWRK00MAS.off" -print >> ${PO_DIR}/cpio-off
find ${CLAIM_DIR} -follow -name "CHECK00WRK.cycle" -print >> ${PO_DIR}/cpio-off
timex cpio -ocvBL < ${PO_DIR}/cpio-off > /dev/rmt/${TAPE}
rm ${PO_DIR}/cpio-off

exit 0
