#!/bin/ksh
#
# Program Name	: mv_pdein.sh <wt directory tp pull files from>
# Description	: Moves 3 PDE Return files from ault-24 
# Author	: Linda S. Jefferis
# Date		: 11/06/2011
# Modifications	: 06/12/2012 - Added argument for wt directory
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE="null"
WT_DIR="/usr/lnk/wt"
#AULT_TR=/usr/lnk/wt/ault-24/ToPDMI
RESP_FILE=RSP.PDFS_RESP
ERROR_FILE=RPT.DDPS_ERROR_SUMMARY
TRANS_FILE=RPT.DDPS_TRANS_VALIDATION
PDE_DIR=/usr/lnk/pde/in
MAIL_PROG=/bin/mail
MAIL_TO="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mv_pdein.sh <wt directory to pull files from>

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

if [ $# -lt 1 ]
then
	usage
	exit
fi
AULT_TR=$1/ToPDMI

mv ${WT_DIR}/${AULT_TR}/${RESP_FILE}.* ${PDE_DIR}
mv ${WT_DIR}/${AULT_TR}/${ERROR_FILE}.* ${PDE_DIR}
mv ${WT_DIR}/${AULT_TR}/${TRANS_FILE}.* ${PDE_DIR}

ls -1 ${PDE_DIR}/R* | ${MAIL_PROG} -s "PDE Return File List" ${MAIL_TO}

exit 0
