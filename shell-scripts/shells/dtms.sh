#!/bin/sh
#
# Program Name	: dtms.sh
# Description	: 
# Author	: Linda S. Jefferis
# Date		: 04/16/97
# Modifications : 08/04/2017 - add dtms06
#		: 06/04/2020 - add inter02
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
INTERFILE="/usr/lnk/dtms/INTER00MAS.new"
MAIL_TO=operations@pdmi.com
MAIL_PROG="/usr/bin/mutt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dtms.sh 

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

${SHELL_DIR}/dtms01.sh > ${RPT_DIR}/dtms01.txt 2>&1
${SHELL_DIR}/dtms06.sh > ${RPT_DIR}/dtms06.txt 2>&1
${SHELL_DIR}/dtms04.sh > ${RPT_DIR}/dtms04.txt 2>&1
${SHELL_DIR}/dtms05.sh > ${RPT_DIR}/dtms05.txt 2>&1
${SHELL_DIR}/inter02.sh -f ${INTERFILE} > ${RPT_DIR}/inter02.txt 2>&1

echo "Attached are the Monthly DTMS Process Reports" | /usr/bin/mutt -s "Monthly DTMS" operations@pdmi.com -a /usr/lnk/rpt/dtms01.txt -a /usr/lnk/rpt/dtms06.txt -a /usr/lnk/rpt/dtms04.txt -a /usr/lnk/rpt/dtms05.txt -a /usr/lnk/rpt/inter02.txt

exit 0
