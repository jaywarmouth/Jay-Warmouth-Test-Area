#!/bin/ksh
#
# Program Name	: proc_audit.sh
# Description	: Create new proc_audit file nightly with correct permissions
# Author	: Anthony DePinto
# Date		: 12-6-96
# Modifications :
#
# Variables Used:
DATE=`date +%m%d%y`
AUDIT_FILE=/usr/lnk/audit

#
# Main routine
#

# Check command line validity, call usage if incorrect
touch ${AUDIT_FILE}/proc_audit-${DATE}
chmod 664 ${AUDIT_FILE}/proc_audit-${DATE}

exit 0
