#!/bin/ksh
#
# Program Name	: backup-mon.sh
# Description	: Backup mon-cycle files to tape
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
MED_DIR="/usr/lnk/medispan"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: backup-mon.sh 

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

find . -follow -name "*CL11*" -print > ${PO_DIR}/cpio-mon
find . -follow -name "*CL13*" -print >> ${PO_DIR}/cpio-mon
find . -follow -name "*CL32*" -print >> ${PO_DIR}/cpio-mon
find . -follow -name "*CL34*" -print >> ${PO_DIR}/cpio-mon
find . -follow -name "*CL36*" -print >> ${PO_DIR}/cpio-mon
find . -follow -name "*CL38*" -print >> ${PO_DIR}/cpio-mon
find . -follow -name "*CL39*" -print >> ${PO_DIR}/cpio-mon
find . -follow -name "*CL57*" -print >> ${PO_DIR}/cpio-mon
find . -follow -name "*CL19-L11" -print >> ${PO_DIR}/cpio-mon
find . -follow -name "*CA07*" -print >> ${PO_DIR}/cpio-mon
find . -follow -name "*CA08*" -print >> ${PO_DIR}/cpio-mon
find . -follow -name "*.PCX" -print >> ${PO_DIR}/cpio-mon
find ${MED_DIR} -follow -name "claim34" -print >> ${PO_DIR}/cpio-mon
find ${TAPE_DIR} -follow -name "*" -print >> ${PO_DIR}/cpio-mon
find ${KEY_DIR} -follow -name "*" -print >> ${PO_DIR}/cpio-mon
find ${CLAIM_DIR} -follow -name "EMBOS00MAS.cd07" -print >> ${PO_DIR}/cpio-mon
find ${CLAIM_DIR} -follow -name "CLWRK00MED" -print >> ${PO_DIR}/cpio-mon
find ${CLAIM_DIR} -follow -name "CLAIM56MAS" -print >> ${PO_DIR}/cpio-mon
find ${CLAIM_DIR} -follow -name "CLAIM31MAS" -print >> ${PO_DIR}/cpio-mon
timex cpio -ocvBL < ${PO_DIR}/cpio-mon > /dev/rmt/${TAPE}
rm ${PO_DIR}/cpio-mon

exit 0
