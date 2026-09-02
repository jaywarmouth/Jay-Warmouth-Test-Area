#!/bin/ksh
#
# Program Name	: week4.sh
# Description	: Twice-Cycle Report and Update 
#		  Command Line Arguments:
#		  -p <prefix> - p/e prefix (e.g. J15)
# Author	: Linda S. Jefferis
# Date		: 05/31/2005
# Modifications : 08/15/2005 - Changed /fs12 path  (LSJ)
#		: 10/26/2005 - Changes for Linux  (LSJ)
#		: 10/25/2006 - Removed char_repl logic  (LSJ)
#		: 02/23/2007 - Changed BAL_RPT from getting emailed to copying to /usr/lnk/rb_01 for Warehouse  (LSJ)
#		: 03/05/2007 - Added email notification to warehouse  (LSJ)
#		: 03/10/2008 - Added claim72pdmtst logic  (LSJ)
#               : 09/08/2008 - Logic to copy file between Husk and Firefly  (LSJ
#		: 09/22/2008 - Added scp of BAL_RPT  (LSJ)
#		: 10/13/2009 - Changed scp of files to s1firefly  (LSJ)
#		: 01/15/2010 - COLO conversion changes  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
FILE_PATH="/usr/lnk/tmp"
PREFIX="null"
SQL_DIR="/usr/lnk/wh"
S1_SQL_DIR="/usr/pdm/sqlimports/claims"
SQL_FILE="WEEKCLMS"
TST_SQL_FILE="WEEKCLMS-TST"
BAL_RPT="???CL16-SYS-INV-W"
BAL_RPT_DIR="/usr/lnk/misc"
MAIL_PROG="/bin/mail"
MAIL_WHSE="warehouse@pdmi.com"
SERVER="`/bin/hostname -s`"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: week4.sh -p <prefix>
	-p <prefix> - 3-char p/e prefix (e.g. J15):  Required argument

ENDOFUSAGE
  exit 1
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
${SHELL_DIR}/claim72pdm.sh -c week > ${RPT_DIR}/week-claim72pdm 2>&1
#${SHELL_DIR}/claim72pdmtst.sh -c week > ${RPT_DIR}/week-claim72pdmtst 2>&1

date

echo "--> claim72pdm completed"
echo ""
echo "--> Moving file for Warehouse"
echo ""
mv ${FILE_PATH}/${PREFIX}CL72-W-PDM ${SQL_DIR}/${SQL_FILE}
#mv ${FILE_PATH}/${PREFIX}CL72TST-W-PDM ${SQL_DIR}/${TST_SQL_FILE}
scp ${SQL_DIR}/${SQL_FILE} ${REMOTE_SYS}:${S1_SQL_DIR}
cp ${BAL_RPT_DIR}/${BAL_RPT} ${SQL_DIR}
scp ${SQL_DIR}/${BAL_RPT} ${REMOTE_SYS}:${S1_SQL_DIR}
if test -s ${SQL_DIR}/${SQL_FILE}
then
	echo "The week-cycle claims refresh file, WEEKCLMS, is now available." | ${MAIL_PROG} -s "WEEK-CYCLE CLAIMS REFRESH" ${MAIL_WHSE}
else
	echo "No extract file created. Look for possible issue." | ${MAIL_PROG} -s "WEEK_CYCLE CLAIMS REFRESH" ${MAIL_OPER}
fi

date


exit 0
