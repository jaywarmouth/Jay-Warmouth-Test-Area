#!/bin/ksh
#
# Program Name  : rm-tweek.sh
# Description   : Removal of tweek-cycle files
#                 Command line arguments:
# Author        : Linda S. Jefferis
# Date          : 10/29/2010
# Modification	: 09/17/2014 - Added email notification and "-f" option to rm commands where needed.
#		: 01/12/2016 - add ???CL16-SYS-INVTOT-X
#		: 06/02/2016 - TT15075-5 remove AEBS files
#		: 06/20/2016 - TT15288-48 - PAF and clmrt01 files
#               : 1/9/2018 - TT17821-4; removal of PRAT related files.
#               : 4/5/2018 - TT18486-54; changes for AHF terminations.
#		: 6/25/2018 - TT13915-64; removal of rentnet files
#               : 07/06/2018 - TT18645-20; add LLS (sys0185) files
#
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
TAPE_DIR="/usr/lnk/tapes"
KEY_DIR="/usr/lnk/keys"
TMP_DIR="/usr/lnk/tmp"
GRP_DIR="/usr/upd/grp"
RPT_DIR="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"
RXEOB_DIR="/usr/lnk/rxeob"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rm-tweek.sh 

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
find sys???? -follow -name "*CL1[6-7]?-X*" -exec rm {} \;
find sys???? -follow -name "*SUSP-X*" -exec rm {} \;
echo "po reports files are removed"
rm -f ${MISC_DIR}/*CL16-SYS-INV-X
rm -f ${MISC_DIR}/*CL16-SYS-INVTOT-X
rm -f ${MISC_DIR}/*CL68-X
rm -f ${MISC_DIR}/*PRINT-CL16-X
rm -f ${MISC_DIR}/tweek-PRINT-CLAIM59-CYCLE-*
echo "misc files are removed"
rm -f ${GRP_DIR}/SUSPWRKMAS-X
rm -f ${GRP_DIR}/INLGWRKMAS-X

rm -f ${TAPE_DIR}/???CL111D0-X-*
rm -f ${TAPE_DIR}/????CLMRTPA
rm -f ${TAPE_DIR}/????PATEXT
rm -f ${TAPE_DIR}/????CLMRTLL
rm -f ${TAPE_DIR}/????LLTEXT
rm -f ${TAPE_DIR}/????CLMRTFB
rm -f ${TAPE_DIR}/????FBTEXT
rm -f ${TAPE_DIR}/????CLMRTCI
rm -f ${TAPE_DIR}/????CITEXT
rm -f ${TAPE_DIR}/???-X-*TEXT

parse_env

rm -f ${CLAIM68KEY}-X
rm -f ${CLAIM46KEY}-X
rm -f ${CLAIM47KEY}-X
rm -f ${CLAIM16KEY}-X
rm -f ${CLAIM55KEY}-X
rm -f ${REVER03KEY}-X
rm -f ${CLMRT01KEY}-X
rm -f ${CLAIM111KEY}-D0-X


rm -f ${RPT_DIR}/tweek-*


exit 0
