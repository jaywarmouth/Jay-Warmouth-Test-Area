#!/bin/sh
#
# Program Name	: week-files.sh
# Description	: Week-cycle file creation procedures
# Author	: Linda S. Jefferis
# Date		: 06/27/05
# Modifications : 08/08/2005 - Added claim106  (LSJ)
#		: 02/10/2006 - Addition of claim109  (LSJ)
#		: 07/05/2006 - Removed claim109 run; PMRX/HAXCB indicate they don't need this file  (LSJ)
#		: 11/06/2006 - Commented out lp commands  (LSJ)
#		: 02/09/2007 - Removed claim106, as per Allan's request  (LSJ)
#		: 12/21/2009 - Added claim109 for CAB file  (LSJ)
#		: 01/12/2010 - Added claim111rx process (LSJ)
#		: 04/05/2011 - Added email and PDF logic  (LSJ)
#		: 06/23/2011 - Added claim109do  (LSJ)
#		: 07/11/2011 - Add claim109gran  (LSJ)
#		: 01/09/2012 - Add claim111d0 
#		: 01/10/2012 - Removed claim109
#		: 10/07/2012 - Add clmrt01 and remove claim119
#               : 06/27/2014 - Add "-v" option to always create version 5010 formatted files instead of using entry in OUTDEM
#		: 07/08/2014 - Add claim109hcrm.sh process
#		: 09/21/2018 - Removal of claim109d0
#		: 11/12/2019 - Change "a2ps" to "enscript"
#		: Remove logic for claim111rx files
#		: 7/26/20922 - Task 45933 - remove claim109gran logic
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT_DIR="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: week-files.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim111d0.sh -c week > ${RPT_DIR}/week-claim111d0 2>&1
${SHELL_DIR}/clmrt01.sh -c week -v > ${RPT_DIR}/week-clmrt01 2>&1

# Convert output files to PDF and email
echo "### week-claim111d0 ###" > ${RPT_DIR}/week-week-files
cat ${RPT_DIR}/week-claim111d0 >> ${RPT_DIR}/week-week-files
echo "### week-clmrt01 ###" >> ${RPT_DIR}/week-week-files
cat ${RPT_DIR}/week-clmrt01 >> ${RPT_DIR}/week-week-files

enscript -Rgj --non-printable-format=space -o - ${RPT_DIR}/week-week-files | ps2pdf - ${RPT_DIR}/week-week-files.pdf

echo "Output from week-files.sh process" | ${MAIL_PROG} -s "Week-cycle - week-files" ${MAIL_TO} -a ${RPT_DIR}/week-week-files.pdf 

exit 0
