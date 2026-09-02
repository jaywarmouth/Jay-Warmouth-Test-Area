#!/bin/ksh
#
# Program Name	: qrt-rebates.sh
# Description	: 
# Author	: Linda S. Jefferis
# Date		: 05/07/2002
# Modifications : 09/09/2002 - Made input sponsor# on rebate11 8-digits  (LSJ) 
#		: 05/07/2004 - Added procedures for sys53  (LSJ)
#		: 06/15/2005 - Removed rebate11 procedures  (LSJ)
#		: 05/04/2006 - Added rebate10 for Medicare Part D files  (LSJ)
#		: 11/21/2011 - Changed to only run Centocor
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: qrt-rebates.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    IFS=${OLDIFS}
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

# Check command line validity, call usage if incorrect

# Parse environment variables
#parse_env

${SHELL_DIR}/rebate10-special.sh -p -t 0048 -m CENTOCOR > ${RPT_DIR}/rebate10 2>&1
${SHELL_DIR}/rebate10-special.sh -p -t 0053 -m CENTOCOR >> ${RPT_DIR}/rebate10 2>&1

# Convert output files to PDF and email
a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/rebate10 | ps2pdf - ${RPT_DIR}/rebate10.pdf

echo "Output from qrt-rebates.sh process" | ${MAIL_PROG} -a ${RPT_DIR}/rebate10.pdf -s "Aultcare - Quarterly Rebates" ${MAIL_TO}

exit 0
