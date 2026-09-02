#!/bin/sh
#
DEST=/usr/lnk/wt/ccai-wt/Reports
PO_DIR=/usr/lnk/po/sys0106
DATE=`date +%Y%m%d`

# Statements
a2ps -1Bl82 -a2- -o - ${PO_DIR}/???CL28Z-C.P1 | ps2pdf - ${DEST}/ccai-statements-${DATE}.pdf

# Checks
a2ps -1Bl82 -o - ${PO_DIR}/???CL06Z-C.CH | ps2pdf - ${DEST}/ccai-checks-${DATE}.pdf

# Check Register
a2ps -1Bl132 -o - ${PO_DIR}/0106-CHK-REGISTER | ps2pdf - ${DEST}/ccai-checkregister-${DATE}.pdf
