#!/bin/ksh
#
# Program Name	: twice4.sh
# Description	: Twice-Cycle Report and Update 
#		  Command Line Arguments:
#		  -p <prefix> - p/e prefix (e.g. J15)
# Author	: Linda S. Jefferis
# Date		: 12/09/2004
# Modifications : 10/26/2005 - Changes for Linux  (LSJ)
#		: 01/17/2006 - Removed lp of rpt file  (LSJ)
#		: 10/25/2006 - Removed char_repl logic  (LSJ)
#		: 07/16/2007 - Logic changes for BAL_RPT as per request from warehouse  (LSJ)
#		: 09/20/2007 - Added validation check and error email for SQL_FILE  (LSJ)
#               : 09/08/2008 - Logic to copy file between Husk and Firefly  (LSJ)
#		: 09/22/2008 - Added scp of BAL_RPT  (LSJ)
#		: 10/13/2009 - Changed scp to s1firefly  (LSJ)
#		: 01/15/2010 - Changed for COLO conversion  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE_PATH="/usr/lnk/tmp"
PREFIX="null"
SQL_DIR="/usr/lnk/wh"
S1_SQL_DIR="/usr/pdm/sqlimports/claims"
SQL_FILE="BIMOCLMS"
MAIL_PROG="/bin/mail"
BAL_RPT="???CL16-SYS-INV-T"
BAL_RPT_DIR="/usr/lnk/misc"
MAIL_WHSE="warehouse@pdmi.com"
MAIL_OPER="operations@pdmi.com"
SERVER="`/bin/hostname -s`"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: twice4.sh -p <prefix>
	-p <prefix> - 3-char p/e prefix (e.g. J15):  Required argument

ENDOFUSAGE
  exit 1
}

#
# Process for S1
s1_process()
{
	gzip ${SQL_DIR}/${SQL_FILE}
	scp ${SQL_DIR}/${SQL_FILE}.gz ${REMOTE_SYS}:${S1_SQL_DIR}
	ssh ${REMOTE_SYS} "gunzip ${S1_SQL_DIR}/${SQL_FILE}.gz"
	scp ${SQL_DIR}/${BAL_RPT} ${REMOTE_SYS}:${S1_SQL_DIR}
	gunzip ${SQL_DIR}/${SQL_FILE}.gz
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	PREFIX=$1
	;;
  esac
  shift
done

case ${SERVER} in
  "husk")
        REMOTE_SYS="prod11"
        ;;
esac


rm -f ${SQL_DIR}/${SQL_FILE}

date

echo "--> Running claim72pdm"
echo ""
${SHELL_DIR}/claim72pdm.sh -c twice > ${RPT_DIR}/twice-claim72pdm 2>&1

date

echo "--> claim72pdm completed"
echo ""
echo "--> Moving file for Warehouse"
echo ""
mv ${FILE_PATH}/${PREFIX}CL72-T-PDM ${SQL_DIR}/${SQL_FILE}
cp ${BAL_RPT_DIR}/${BAL_RPT} ${SQL_DIR}
s1_process
if test -s ${SQL_DIR}/${SQL_FILE}
then
	echo "The twice-cycle claims refresh file, BIMOCLMS, is now available." | ${MAIL_PROG} -s "TWICE_CYCLE CLAIMS REFRESH" ${MAIL_WHSE}
else
	echo "No extract file created. Look for possible issue." | ${MAIL_PROG} -s "TWICE_CYCLE CLAIMS REFRESH" ${MAIL_OPER}
fi

date


exit 0
