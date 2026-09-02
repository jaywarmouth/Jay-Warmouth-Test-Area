#!/bin/sh
#
# Program Name	: hdupd.sh
# Description	: Runs file extracts for updating to Helpdesk database
# Author	: Linda Jefferis
# Date		: 02/28/2001
# Modifications : 03/01/2001 - Uncommented run of system01  (LSJ)
#		: 06/11/2003 - Changed pharm03 to run each night  (LSJ)
#		: 02/20/2006 - Added umask command  (LSJ)
#		: 01/18/2007 - Changes for running on Rook and copying files to Husk  (LSJ)
#		: 05/27/2010 - Changes for new clientfiles output location
#		: 04/30/2015 - TT:283-39 (Remove reject02 logic; moved to other daily process)
#
# Variables Used:
PATH=/opt/rmcobol:$PATH
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
ZIP_PROG="/bin/gzip"
SQL_DIR="/usr/lnk/wt/sqlimports"
OUT_DIR="misc"
FILE_DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: hdupd.sh 

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
# Transfer file
file_transfer()
{
if test -e ${FNAME}
then
        gzip ${FNAME}
        mv ${FNAME}.gz ${SQL_DIR}/${OUT_DIR}
        if test $? -ne 0
        then
                echo "Error with transfer of ${FNAME}"
        fi
else
        echo "${FNAME} does not exist"
fi
}


#
# Main routine
#

umask 002

parse_env

echo "Help Desk TV Update Files"

echo
echo "--> System extract - system01"
${SHELL_DIR}/system01.sh > ${RPT_DIR}/system01 2>&1
mv ${SYSTERB001} ${SYSTERB001}-${FILE_DATE}
FNAME=${SYSTERB001}-${FILE_DATE}
file_transfer
echo "     `grep "COUNT" ${RPT_DIR}/system01`"

echo
echo "--> Pharmacy extract - pharm03"
${SHELL_DIR}/pharm03.sh > ${RPT_DIR}/pharm03 2>&1
mv ${PHARMRB001} ${PHARMRB001}-${FILE_DATE}
FNAME=${PHARMRB001}-${FILE_DATE}
file_transfer
echo "     `grep "COUNT" ${RPT_DIR}/pharm03`"

exit 0
