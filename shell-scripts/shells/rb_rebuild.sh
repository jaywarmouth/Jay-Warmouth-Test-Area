#!/bin/ksh
#
# Program Name	: rb_rebuild.sh
# Description	:  
# Author	: Linda S. Jefferis
# Date		: 01/23/98
# Modifications :
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rb_rebuild.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim72pdm.sh -r "7C00A0007D00A000/usr/rb_data_04/rb_pdm_mar97  " -f /usr/clm_05/CLAIMS_qu1_97 > ${RPT_DIR}/claim72pdm.rebld 2>&1
compress /usr/rb_data_04/rb_pdm_mar97
${SHELL_DIR}/claim72pdm.sh -r "7F00A0007G00A000/usr/rb_data_04/rb_pdm_jun97  " -f /usr/clm_05/CLAIMS_qu2_97 >> ${RPT_DIR}/claim72pdm.rebld 2>&1
compress /usr/rb_data_04/rb_pdm_jun97
${SHELL_DIR}/claim72pdm.sh -r "7J00A0007K00A000/usr/rb_data_04/rb_pdm_oct97  " -f /usr/clm_01/CLAIM00MAS >> ${RPT_DIR}/claim72pdm.rebld 2>&1
compress /usr/rb_data_04/rb_pdm_oct97
${SHELL_DIR}/claim72pdm.sh -r "7K00A0007L00A000/usr/rb_data_04/rb_pdm_nov97  " -f /usr/clm_01/CLAIM00MAS >> ${RPT_DIR}/claim72pdm.rebld 2>&1
compress /usr/rb_data_04/rb_pdm_nov97
${SHELL_DIR}/claim72pdm.sh -r "7L00A0008A00A000/usr/rb_data_04/rb_pdm_dec97  " -f /usr/clm_01/CLAIM00MAS >> ${RPT_DIR}/claim72pdm.rebld 2>&1
compress /usr/rb_data_04/rb_pdm_dec97

exit 0
