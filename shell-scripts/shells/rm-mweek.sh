#!/bin/ksh
#
# Program Name  : rm-mweek.sh
# Description   : Removal of twice-cycle files
# Author        : Linda S. Jefferis
# Date          : 12/29/2009
# Modifications : 
#
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
KEY_DIR="/usr/lnk/keys"
TMP_DIR="/usr/lnk/tmp"
GRP_DIR="/usr/upd/grp"
RPT_DIR="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rm-mweek.sh -p <p/e prefix>

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
#
# Main routine
#

cd ${PO_DIR}
find sys0048 -follow -name "*CL1[6-7]?-T*" -exec rm {} \;
echo "po reports files are removed"
rm -f ${MISC_DIR}/???CL16-SYS-INV-T
rm -f ${MISC_DIR}/*PRINT-CL16-T
echo "misc files are removed"
rm ${GRP_DIR}/SUSPWRKMAS-X
rm ${GRP_DIR}/INLGWRKMAS-X

parse_env

rm ${CLAIM16KEY}-X
rm ${CLAIM55KEY}-X

rm ${RPT_DIR}/mweek-*

exit 0
