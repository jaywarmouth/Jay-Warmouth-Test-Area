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
RB_DIR="/usr/rb_data_07"

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

find . -follow -name "*CL29*" -print > ${PO_DIR}/cpio-qrt
find . -follow -name "*CL33*" -print >> ${PO_DIR}/cpio-qrt
find . -follow -name "*CL19*" -print >> ${PO_DIR}/cpio-qrt
find . -follow -name "*CL82*" -print >> ${PO_DIR}/cpio-qrt
find ./sys01 -follow -name "prm*" -print >> ${PO_DIR}/cpio-qrt
find ${KEY_DIR} -follow -name "*" -print >> ${PO_DIR}/cpio-qrt
find ${CLAIM_DIR} -follow -name "CLAIM33MAS" -print >> ${PO_DIR}/cpio-qrt
find ${RB_DIR} -follow -name "CLAIM29MAS" -print >> ${PO_DIR}/cpio-qrt
find ${RB_DIR} -follow -name "CLAIM81MAS" -print >> ${PO_DIR}/cpio-qrt
timex cpio -ocvBL < ${PO_DIR}/cpio-qrt > /dev/rmt/${TAPE}
rm ${PO_DIR}/cpio-qrt

exit 0
