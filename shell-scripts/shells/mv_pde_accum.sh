#!/bin/ksh
#
# Program Name	: mv_pde_accum.sh <wt directory tp pull files from>
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
PDE_ACCUM="RPT.DDPS_P2P_PDE_ACUM_PDP"
PDE_DIR=/usr/lnk/pde/in
MAIL_PROG=/bin/mail
MAIL_TO="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mv_pde_accum.sh <wt directory to pull files from>

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

mv ${WT_DIR}/${AULT_TR}/${PDE_ACCUM}.* ${PDE_DIR}

ls -1 ${PDE_DIR}/${PDE_ACCUM}.* | ${MAIL_PROG} -s "PDE P2P Accum File List" ${MAIL_TO}

exit 0
