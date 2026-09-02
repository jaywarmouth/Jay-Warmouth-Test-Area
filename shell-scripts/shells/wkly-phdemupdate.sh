#!/bin/sh
#

RETVAL=0
SHELL_DIR=/usr/lnk/shell
RPT_DIR=/usr/lnk/rpt
PATH=/usr/rmcobol:$PATH

${SHELL_DIR}/phdem05.sh > ${RPT_DIR}/phdem05 2>&1

${SHELL_DIR}/phdem04.sh > ${RPT_DIR}/phdem04 2>&1

