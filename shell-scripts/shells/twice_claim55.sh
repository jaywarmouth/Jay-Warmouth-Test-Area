#!/bin/ksh
#
# Program Name	: twice_claim55.sh
# Description	: Runs claim55.sh and cla55_rbextract_twice.sh
# Author	: Linda S. Jefferis
# Date		: 12/28/2004
# Modifications : 
#               : 09/20/2007 - Added automatic email to warehouse  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
SHELL_TST="/usr/lnk/tstshl"
RPT="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_WHSE="warehouse@pdmi.com"
MAIL_OPER="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: twice_claim55.sh 

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

${SHELL_DIR}/claim55.sh -c twice -m -y > ${RPT}/twice-claim55 2>&1
${SHELL_DIR}/cla55_rbextract_twice.sh > ${RPT}/twice-cla55_rbextract 2>&1
if test $? -eq 0
then
	echo "The twice-cycle CLAIM55 extract file, CLAIM55-T, is now available for updating to the warehouses." | ${MAIL_PROG} -s "TWICE_CYCLE CLAIM55" ${MAIL_WHSE}
else
	echo "No extract file created. Look for possible issue." | ${MAIL_PROG} -s "TWICE_CYCLE CLAIM55" ${MAIL_OPER}
fi

exit 0
