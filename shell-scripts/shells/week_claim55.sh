#!/bin/ksh
#
# Program Name	: week_claim55.sh
# Description	: Runs claim55.sh and cla55_rbextract.sh
# Author	: Linda S. Jefferis
# Date		: 05/22/2000
# Modifications : 05/29/2003 - Added "pay-" to names of rpt files (LSJ) 
#		: 04/28/2004 - Removed the "lp" of the rpt files  (LSJ)
#               : 09/20/2007 - Added automatic email to warehouse  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_WHSE="warehouse@pdmi.com"
MAIL_OPER="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: week_claim55.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
	IFS=${EQUAL}
	set $VAR
	NVAR=$1
	export ${NVAR}
        if [ $? -ne 0 ]
        then
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# Main routine
#

${SHELL_DIR}/claim55.sh -c week -m -y > ${RPT}/week-claim55 2>&1
${SHELL_DIR}/cla55_rbextract_week.sh > ${RPT}/week-cla55_rbextract 2>&1
if test $? -eq 0
then
	echo "The week-cycle CLAIM55 extract file, CLAIM55-W, is now available for updating to the warehouses." | ${MAIL_PROG} -s "WEEK_CYCLE CLAIM55" ${MAIL_WHSE}
else
	echo "No extract file created. Look for possible issue." | ${MAIL_PROG} -s "WEEK_CYCLE CLAIM55" ${MAIL_OPER}
fi

exit 0
