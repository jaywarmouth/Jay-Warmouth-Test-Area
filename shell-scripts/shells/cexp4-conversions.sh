#!/bin/sh
#
# Description:  Run all CEXP4 conversions

SHELL_DIR=/usr/lnk/shell
RPT_DIR=/usr/lnk/rpt

echo "Group File Conversion"
${SHELL_DIR}/convertgroup.sh > ${RPT_DIR}/convertgroup 2>&1
echo "Plan File Conversion"
${SHELL_DIR}/planconvert.sh > ${RPT_DIR}/planconvert 2>&1
echo "Benef File Conversion"
${SHELL_DIR}/benefconvert.sh > ${RPT_DIR}/benefconvert 2>&1
echo "Config File Conversion"
${SHELL_DIR}/configconvert.sh > ${RPT_DIR}/configconvert 2>&1
echo "RCP File Conversion"
${SHELL_DIR}/rcpmasconvert01.sh > ${RPT_DIR}/rcpmasconvert01 2>&1
echo "NSDEOVR File Conversion"
${SHELL_DIR}/nsdeovrconvert.sh > ${RPT_DIR}/nsdeovrconvert 2>&1
echo "ETRAF File Conversion"
${SHELL_DIR}/etrafconvert.sh > ${RPT_DIR}/etrafconvert 2>&1

exit 0
