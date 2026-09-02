#!/bin/ksh
#
# Program Name	: twice-week4.sh
# Description	: Twice-Week CL72 file process 
# Author	: Linda S. Jefferis
# Date		: 07/18/2008
# Modifications : 02/25/2009 - Changed email to run on REMOTE_SYS  (LSJ)
#		: 10/26/2009 - Added logic for scp to COLO site  (LSJ)
#		: 11/24/2009 - Fixed scp logic to COLO  (LSJ)
#		: 12/14/2009 - Changed logic for added MEDD week and removed "prefix" logic
#		: 12/29/2009 - Fixed "mv" command
#		: 01/07/2010 - Changed logic again for it being run on Production system
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE_PATH="/usr/lnk/tmp"
PREFIX="null"
REMOTE_SYS="husk"
S1_REMOTE_SYS="prod11"
S1_SQL_DIR="/usr/pdm/sqlimports/claims"
SQL_DIR="/usr/lnk/wh"
SQL_FILE="MIDBIMOCLMS"
MAIL_PROG="/bin/mail"
#MAIL_WHSE="warehouse@pdmi.com"
MAIL_WHSE="ljefferis@pdmi.com"
MAIL_OPER="operations@pdmi.com"
BAL_RPT="/usr/lnk/misc/???CL16-SYS-INV-X"
NEW_BAL_RPT="${SQL_DIR}/CL16-SYS-INV-X"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: twice-week4.sh

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
# Check command line validity, call usage if incorrect


rm -f ${SQL_DIR}/${SQL_FILE}

date

echo "--> Running claim72pdm"
echo ""
${SHELL_DIR}/claim72pdm.sh -c twiceweek > ${RPT_DIR}/tweek-claim72pdm 2>&1

date

echo "--> claim72pdm completed"
echo ""
echo "--> Moving file for Warehouse"
echo ""
grep "0048," ${RPT_DIR}/tweek-claim72pdm > ${NEW_BAL_RPT}
grep "0083," ${RPT_DIR}/tweek-claim72pdm >> ${NEW_BAL_RPT}
scp ${FILE_PATH}/???CL72-X-PDM ${REMOTE_SYS}:${SQL_DIR}/${SQL_FILE}
scp ${FILE_PATH}/???CL72-X-PDM ${S1_REMOTE_SYS}:${S1_SQL_DIR}/${SQL_FILE}
scp ${NEW_BAL_RPT} ${REMOTE_SYS}:${SQL_DIR}
scp ${NEW_BAL_RPT} ${S1_REMOTE_SYS}:${S1_SQL_DIR}
echo "The claims refresh file, MIDBIMOCLMS, is now available." | ssh ${REMOTE_SYS} ${MAIL_PROG} -s '"MIDBIMOCLMS CLAIMS REFRESH"' ${MAIL_WHSE}

date


exit 0
