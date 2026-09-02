#!/bin/ksh
#
# Program Name	: mweek_claim55.sh
# Description	: Runs claim55.sh and cla55_rbextract_mweek.sh
# Author	: Linda S. Jefferis
# Date		: 12/28/2004
# Modifications : 
#		: 01/08/2010 - Changes due to new procedures for MEDD
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

usage: mweek_claim55.sh 

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

${SHELL_DIR}/claim55.sh -c twice -x -m -y > ${RPT}/mweek-claim55 2>&1
${SHELL_DIR}/cla55_rbextract_mweek.sh > ${RPT}/mweek-cla55_rbextract 2>&1
if test $? -eq 0
then
	echo "The mweek-cycle CLAIM55 extract file, CLAIM55-X, is now available for updating to the warehouses." | ${MAIL_PROG} -s "MEDD WEEK-CYCLE CLAIM55" ${MAIL_WHSE}
else
	echo "No extract file created. Look for possible issue." | ${MAIL_PROG} -s "MEDD WEEK-CYCLE CLAIM55" ${MAIL_OPER}
fi

exit 0
