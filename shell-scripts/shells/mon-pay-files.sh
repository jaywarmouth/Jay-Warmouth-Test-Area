#!/bin/ksh
#
# Program Name	: mon-pay-files.sh
# Description	: Mon-Pay-cycle file creation procedures
# Author	: Linda S. Jefferis
# Date		: 03/29/2006
# Modifications : 03/23/2009 - Added claim109nmd  (LSJ)
#		: 04/19/2010 - Added claim109agmc
#		: 05/06/2010 - Removed claim109nmd; file no longer needs provided to NavigatorMD as per email.
#		: 04/26/2011 - Added claim109d0  (LSJ)
#		: 01 05/2012 - Removed claim109
#		: 05/30/2013 - Removed claim129
#		: 1/19/2015 - Remove claim109agmc process (TT #12718-2)
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

usage: mon-pay-files.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

${SHELL_DIR}/claim109d0.sh -c mon > ${RPT_DIR}/mon-p-claim109d0 2>&1

# Convert output files to PDF and email
echo "### mon-p-claim109d0 ###" >> ${RPT_DIR}/mon-p-files
cat ${RPT_DIR}/mon-p-claim109d0 >> ${RPT_DIR}/mon-p-files

a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/mon-p-files | ps2pdf - ${RPT_DIR}/mon-p-files.pdf

echo "Output from mon-pay-files.sh" | ${MAIL_PROG} -a ${RPT_DIR}/mon-p-files.pdf -s "Bi-weekly Month End - mon-pay-files" ${MAIL_TO}

exit 0
