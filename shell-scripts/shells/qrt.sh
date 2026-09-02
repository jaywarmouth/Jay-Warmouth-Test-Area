#!/bin/ksh
#
# Program Name	: qrt.sh
# Description	: Quarter Reports
#		  Command Line Arguments:
#                 -b <batch range>
#			Calendar Quarter start and stop batch
# Author	: Linda S. Jefferis
# Date		: 07/12/96
# Modifications : 05/01/2003 - Changes for new features on claim29 and claim33
#		: 10/18/2004 - Added "qrt-" prefix to rpt output names  (LSJ)
#		: 10/13/2005 - Added '-b' input argument  (LSJ)
#		: 04/24/2006 - Commented out sys level run of claim33.sh  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
BATCH="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: qrt.sh -b <batch range>
	where <batch range> is calendar quarter start and stop batch
		e.g. FG01A000FI30Z999

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
          echo "^G-*> Parse Error on Line: "${VAR}
	fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# Main routine
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
    -b) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	BATCH=$1
	;;
  esac
  shift
done

#
# Parse environment variables
parse_env

${SHELL_DIR}/claim29.sh -b ${BATCH} -g  > ${RPT_DIR}/qrt-claim29 2>&1

#${SHELL_DIR}/claim33.sh -t > ${RPT_DIR}/qrt-claim33 2>&1
#mv ${CLAIM33MAS} ${CLAIM33MAS}.sys

${SHELL_DIR}/claim33.sh -g >> ${RPT_DIR}/qrt-claim33 2>&1
mv ${CLAIM33MAS} ${CLAIM33MAS}.grp

exit 0
