#!/bin/sh
#
#
# Variables Used:
KEY_DIR="/usr/lnk/keys"
MISC_DIR="/usr/lnk/misc"
RPT_DIR="/usr/lnk/rpt"
CYCLE="twice"
PROD_SYS="prod10"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: copy_prod_twice.sh 

ENDOFUSAGE
  exit 1
}

date

scp ${PROD_SYS}:${MISC_DIR}/???CL68-T ${MISC_DIR}
scp ${PROD_SYS}:${MISC_DIR}/twice-PRINT-CLAIM59-CYCLE-T ${MISC_DIR}

scp ${PROD_SYS}:${KEY_DIR}/CLAIM68KEY-T ${KEY_DIR}
scp ${PROD_SYS}:${KEY_DIR}/CLAIM46KEY-T ${KEY_DIR}
scp ${PROD_SYS}:${KEY_DIR}/CLAIM47KEY-T ${KEY_DIR}
scp ${PROD_SYS}:${KEY_DIR}/REVER03KEY-T ${KEY_DIR}

scp ${PROD_SYS}:${RPT_DIR}/${CYCLE}-* ${RPT_DIR}

exit 0
