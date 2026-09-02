#!/bin/sh
#
# Program Name	: medsub_outbound_eligfile.sh
# Description	: Create Medicaid Subrogation Eligibility File for distribution 
# Author	: Linda S. Jefferis
# Date		: 01/25/2018
#
# Variables Used:
DATE=`date +%Y%m%d`
CRDHMS01TAP="/usr/lnk/tapes/CRDHMS01TAP-$DATE"
SEND_FILE="/usr/lnk/wt/oper-wt/MEDSUB/FromPDMI/PDMIELIG.$DATE.txt"
SHELL_DIR=/usr/lnk/shell
RPT_DIR=/usr/lnk/rpt

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: medsub_outbound_eligfile.sh 

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


find /usr/lnk/tapes -follow -name "CRDHMS01TAP-*" -mtime +14 -exec rm {} \;

${SHELL_DIR}/crdhms01.sh > ${RPT_DIR}/crdhms01 2>&1

cat ${RPT_DIR}/crdhms01

cp ${CRDHMS01TAP} ${SEND_FILE}


exit 0
