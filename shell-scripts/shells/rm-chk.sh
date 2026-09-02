#!/bin/sh
#
# Program Name  : rm-chk.sh
# Description   : Removal of chk-cycle files
# Author        : Linda S. Jefferis
#                 Command line arguments:
#                 -p <p/e prefix> (e.g. I20)
# Date          : 09/18/2009
# Modifications : 10/15/2009 - Added TRIGGERMAS
#		: 06/04/2010 - Added nacha01 files
#		: 06/08/2010 - Added EFT0000WRK-ccyymmdd
#		: 07/16/2010 - Added CL07-E and CL28-E files
#		: 06/09/2011 - Added CL58-C.pdf
#		: 10/26/2011 - Added V5010 files
#		: 10/21/2014 - Add KeyBank check outsourcing related files (6939-2)
#		: 04/10/2015 - "FTP_TMP/KEY*" files
#		: 01/01/2018 - TT:13915-59
#		: 02/09/2018 - Removal of /usr/lnk/shares/ftp-tmp/chkrun-CL20.txt
#               : TT13915-64 - Removal of claim70 related files
#		: TT13915-68
#		: 07/21/2022 - enhancement changes
#		: 10/11/2022 - eliminated the removal of TRIGGERMAS
#
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
TAPE_DIR="/usr/lnk/tapes"
KEY_DIR="/usr/lnk/keys"
GRP_DIR="/usr/upd/grp"
RPT_DIR="/usr/lnk/rpt"
CLM_DIR="/usr/upd/claims"
TMP_DIR="/usr/lnk/tmp"
WT_DIR="/usr/lnk/wt/pdm"
MISC_DIR="/usr/lnk/misc"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rm-chk.sh -p <p/e prefix>

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
while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        PREFIX=$1
        ;;
  esac
  shift
done

cd ${PO_DIR}
find . -follow -name "*CL07?-C*" -exec rm {} \;
find . -follow -name "*CL07?-E*" -exec rm {} \;
find . -follow -name "*CL37?-C*" -exec rm {} \;
find . -follow -name "*CL20?-C*" -exec rm {} \;
find . -follow -name "*-CHK-REGISTER*" -exec rm {} \;

rm -f ${MISC_DIR}/*CL88-C* 
rm -f ${MISC_DIR}/*CL58-C* 
rm -f ${MISC_DIR}/CL??-C-TOTALS
rm -f ${MISC_DIR}/CL127-C-TOTALS
rm -f ${MISC_DIR}/???CL07-C-ZEROCHK
rm -f ${MISC_DIR}/SYS-CHK-TOTALS
rm -f ${MISC_DIR}/PRINT-SUSP002
rm -f ${MISC_DIR}/NACHA01-*
rm -f ${MISC_DIR}/KEYCARDERR*
rm ${MISC_DIR}/???-*-X12-ERR ${MISC_DIR}/???-*-X12-IR-ERR
rm ${GRP_DIR}/INLGWRKMAS-C
rm ${CLM_DIR}/CHKWRK-C
rm ${TMP_DIR}/EFT0000WRK-*
rm ${WRK_DIR}/CL58-C.pdf
rm -f ${WT_DIR}/chkrun/chkrun-CL20.txt
rm -f ${WT_DIR}/chkrun/chkwrk-*.txt

rm -f ${TAPE_DIR}/???NHIN-V5010
rm -f ${TAPE_DIR}/???????-V5010-LINE
rm -f ${TAPE_DIR}/???????-V5010
rm -f ${TAPE_DIR}/???????-V5010-TEXT
rm -f ${TAPE_DIR}/NACHA-*
rm -f ${TAPE_DIR}/KEY*.arm.kbarm

rm -f ${RPT_DIR}/chk-*

parse_env

rm ${CLAIM88KEY}
rm ${CLAIM20KEY}
rm ${RECONX12KEY}
rm ${CLAIM37KEY}
rm ${CLAIM07KEY}
rm ${CLM07TOTKEY}

# Misc pdf files
rm -f ${MISC_DIR}/CL??-C-TOTALS.pdf
rm -f ${MISC_DIR}/CL88-C.pdf
rm -f ${MISC_DIR}/PRINT-SUSP002.pdf
rm -f ${MISC_DIR}/SYS-CHK-TOTALS.pdf

# reconx12 files
find ${WT_DIR}/reconx12/chk -name "*-V5010*" -exec rm -f {} \;
rm -f ${WT_DIR}/reconx12/chk/CVSC/*

# CLWRK files
rm ${TMP_DIR}/CLWRK00MAS.chk
rm ${TMP_DIR}/CLWRK00MAS.chk.*

exit 0
