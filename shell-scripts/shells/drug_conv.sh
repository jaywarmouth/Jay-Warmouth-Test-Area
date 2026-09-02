#!/bin/ksh
#
# Program Name	: drug_conv.sh
# Description	: 
# Author	: Linda S. Jefferis
# Date		: 05/20/2002
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FLEX="/usr/lnk/flexgen"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug_conv.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

date
${SHELL_DIR}/cp_drug_files.sh > ${RPT_DIR}/cp_drug_files 2>&1
date

su ljefferi

cd ${FLEX}
date
echo "--> Running the Initialize procedure - drgpc003.cs"
drgpc003.cs
date

rm ${RPT_DIR_2}/*-PRINT-DRUG005
rm ${RPT_DIR_2}/PRINT-DRUG0*
${SHELL_DIR}/drug008.sh > ${RPT_DIR}/drug008 2>&1
${SHELL_DIR}/drug010.sh > ${RPT_DIR}/drug010 2>&1

date

exit 0
