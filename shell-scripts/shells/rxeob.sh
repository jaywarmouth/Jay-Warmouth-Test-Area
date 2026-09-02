#!/bin/sh
#
# Program Name	: rxeob.sh
# Description	: Does batch run of the RXEOB extract procedures
# Author	: Linda Jefferis
# Date		: 11/23/2001
# Modifications : 01/31/2002 - Added PLAN section
#		: 02/25/2002 - Added COPAY section  (LSJ)
#		: 03/22/2004 - Addition of mac003 procedure  (LSJ)
#		: 01/25/2005 - Addition of ohlimpc001 procedure  (LSJ)
#		: 06/27/2005 - Added umask command  (LSJ)
#		: 07/13/2005 - Addition of pharm01 procedure  (LSJ)
#		: 10/26/2005 - Changes for Linux  (LSJ)
#		: 08/31/2007 - Added override and exception procedures  (LSJ)
#		: 05/18/2011 - Addition of ohgenpc002 process  (LSJ)
#		: 09/04/2013 - Addition of copy, transfer, and cleanup for claims processes (DME)
#		: 05/09/2023 - Changed logic for archive location (LSJ)
#
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
FILE_DATE=`date +%Y%m%d`
NETWRK_DIR="/usr/lnk/rxeob"
CLM_FILE="rxeobclms_${FILE_DATE}.zip"
ARCH_DIR="/usr/lnk/rptarch/daily"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
TR_ID="RXEOB-GA"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rxeob.sh 

ENDOFUSAGE
  exit 1
}

#
# Transfer Claims Files
claims_transfer()
{
	${TR_PROG} ${TR_ID} ${NETWRK_DIR}/${CLM_FILE}
           if test $? -ne 0
             then
                echo "*-> Transfer of claims file failed"
		claims_cleanup
                exit 1
           fi
}

#
#Claims Cleanup
claims_cleanup()
{
	  mv ${NETWRK_DIR}/${CLM_FILE} ${ARCH_DIR}
}

#
# Main routine
#

umask 002

# Daily Claims
echo
echo "*-> Running - rxeob_clms.sh"
${SHELL_DIR}/rxeob_clms.sh 2>&1
echo

echo
echo "*-> Transferring Claims File..."
echo

claims_transfer

echo
echo "*-> Cleaning up..."
echo 

claims_cleanup

echo "*-> Finished."

exit 0
