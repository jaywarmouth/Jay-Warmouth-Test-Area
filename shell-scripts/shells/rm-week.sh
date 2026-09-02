#!/bin/ksh
#
# Program Name  : rm-week.sh
# Description   : Removal of week-cycle files
# Author        : Linda S. Jefferis
# Date          : 06/28/2005
#		: 01/12/2016 - add ???CL16-SYS-INVTOT-W, remove PREFIX logic, and a few other cleanup items.
#		: 03/21/2016 - TT15074-4 Add CLMRTTB files
#		: 12/22/2016 - TT16314-12 Add CLMRTRP files
#		: 02/12/2018 - Add CLMRTXM files
#               : 09/21/2018 - Removal of claim109d0 related files
#		: 11/04/2020 - Remove logic for claim111rx files
#               : 7/26/20922 - Task 45933 - remove claim109gran logic
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
CLAIMS_DIR="/usr/upd/claims"
RPT_DIR="/usr/lnk/rpt"
MISC_DIR="/usr/lnk/misc"
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
RXEOB_DIR="/usr/lnk/rxeob"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rm-week.sh 

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
# Check command line validity, call usage if incorrect

cd ${PO_DIR}
find sys???? -follow -name "*CL1[6-7]?-W*" -exec rm {} \;
rm -f ${MISC_DIR}/???CL16-SYS-INV-W
rm -f ${MISC_DIR}/???CL16-SYS-INVTOT-W
rm -f ${MISC_DIR}/*CL68-W
rm -f ${MISC_DIR}/*PRINT-CL16-W
rm -f ${MISC_DIR}/wk-PRINT-CLAIM59-CYCLE-W
echo "misc files are removed"
rm -f ${GRP_DIR}/INLGWRKMAS-W
rm -f ${GRP_DIR}/SUSPWRKMAS-W

rm ${TAPE_DIR}/???CL111D0-W-*
rm ${TAPE_DIR}/????CLMRT2P*
rm ${TAPE_DIR}/????2PTEXT
rm ${TAPE_DIR}/????CLMRTAR*
rm ${TAPE_DIR}/????ARTEXT
rm ${TAPE_DIR}/????CLMRTAX*
rm ${TAPE_DIR}/????AXTEXT
rm ${TAPE_DIR}/????CLMRTBA*
rm ${TAPE_DIR}/????BATEXT
rm ${TAPE_DIR}/????CLMRTTB*
rm ${TAPE_DIR}/????TBTEXT
rm ${TAPE_DIR}/????CLMRTRP*
rm ${TAPE_DIR}/????RPTEXT
rm ${TAPE_DIR}/????CLMRTXM*
rm ${TAPE_DIR}/????XMTEXT

parse_env

rm -f ${CLAIM68KEY}-W
rm -f ${CLAIM46KEY}-W
rm -f ${CLAIM47KEY}-W
rm -f ${CLAIM16KEY}-W
rm -f ${CLAIM55KEY}-W
rm -f ${REVER03KEY}-W
rm -f ${CLAIM111RXKEY}-W
rm -f ${CLAIM111KEY}-D0-W
rm -f ${CLMRT01KEY}-W


rm -f ${RPT_DIR}/week-*



exit 0
