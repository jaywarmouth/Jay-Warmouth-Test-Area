#!/bin/sh
#
#
# Variables Used:
KEY_DIR="/usr/lnk/keys"
MISC_DIR="/usr/lnk/misc"
RPT_DIR="/usr/lnk/rpt"
CYCLE="pay"
PROD_SYS="prod10"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: copy_prod_pay.sh 

ENDOFUSAGE
  exit 1
}

date

scp ${PROD_SYS}:${MISC_DIR}/???CL68-P ${MISC_DIR}
scp ${PROD_SYS}:${MISC_DIR}/pay-PRINT-CLAIM59-CYCLE-P ${MISC_DIR}

scp ${PROD_SYS}:${KEY_DIR}/CLAIM68KEY-P ${KEY_DIR}
scp ${PROD_SYS}:${KEY_DIR}/CLAIM46KEY-P ${KEY_DIR}
scp ${PROD_SYS}:${KEY_DIR}/CLAIM47KEY-P ${KEY_DIR}
scp ${PROD_SYS}:${KEY_DIR}/REVER03KEY-P ${KEY_DIR}

scp ${PROD_SYS}:${RPT_DIR}/${CYCLE}-* ${RPT_DIR}

exit 0
