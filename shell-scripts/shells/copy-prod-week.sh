#!/bin/sh
#
#
# Variables Used:
KEY_DIR="/usr/lnk/keys"
MISC_DIR="/usr/lnk/misc"
RPT_DIR="/usr/lnk/rpt"
CYCLE="week"
PROD_SYS="prod10"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: copy_prod_week.sh 

ENDOFUSAGE
  exit 1
}

date

scp ${PROD_SYS}:${MISC_DIR}/???CL68-W ${MISC_DIR}
scp ${PROD_SYS}:${MISC_DIR}/wk-PRINT-CLAIM59-CYCLE-W ${MISC_DIR}

scp ${PROD_SYS}:${KEY_DIR}/CLAIM68KEY-W ${KEY_DIR}
scp ${PROD_SYS}:${KEY_DIR}/CLAIM46KEY-W ${KEY_DIR}
scp ${PROD_SYS}:${KEY_DIR}/CLAIM47KEY-W ${KEY_DIR}
scp ${PROD_SYS}:${KEY_DIR}/REVER03KEY-W ${KEY_DIR}

scp ${PROD_SYS}:${RPT_DIR}/${CYCLE}-* ${RPT_DIR}

exit 0
