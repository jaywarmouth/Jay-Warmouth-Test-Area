#!/bin/sh
#
#
# Variables Used:
KEY_DIR="/usr/lnk/keys"
MISC_DIR="/usr/lnk/misc"
RPT_DIR="/usr/lnk/rpt"
CYCLE="tweek"
PROD_SYS="prod10"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: copy_prod_tweek.sh 

ENDOFUSAGE
  exit 1
}

date

scp ${PROD_SYS}:${MISC_DIR}/???CL68-X ${MISC_DIR}
scp ${PROD_SYS}:${MISC_DIR}/tweek-PRINT-CLAIM59-CYCLE-X ${MISC_DIR}

scp ${PROD_SYS}:${KEY_DIR}/CLAIM68KEY-X ${KEY_DIR}
scp ${PROD_SYS}:${KEY_DIR}/CLAIM46KEY-X ${KEY_DIR}
scp ${PROD_SYS}:${KEY_DIR}/CLAIM47KEY-X ${KEY_DIR}
scp ${PROD_SYS}:${KEY_DIR}/REVER03KEY-X ${KEY_DIR}

scp ${PROD_SYS}:${RPT_DIR}/${CYCLE}-* ${RPT_DIR}

exit 0
