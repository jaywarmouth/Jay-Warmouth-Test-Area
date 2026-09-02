#!/bin/sh
#
# Program Name  : rm-twice.sh
# Description   : Removal of twice-cycle files
#                 Command line arguments:
# Author        : Linda S. Jefferis
# Date          : 12/30/2004
# Modifications : 02/03/2005 - Addition of PRINT-CLAIM59-CYCLE-T  (LSJ)
#		: 02/03/2005 - Addition of claim130 and claim111 files  (LSJ)
#		: 03/02/2005 - Changed claim11 files to claim178 files  (LSJ)
#		: 05/17/2005 - Changes for new "-T" suffix on KEY files  (LSJ)
#		: 06/17/2005 - Addition of claim111 RXEOB files  (LSJ)
#		: 08/09/2005 - Addition of LASH tape files  (LSJ)
#		: 08/09/2005 - Added ???SUMA-DED-T  (LSJ)
#		: 09/27/2005 - Additions for limit48 and claim44  (LSJ)
#		: 10/07/2005 - Additions for clmrt01  (LSJ)
#		: 10/19/2005 - Added xp/sys80/inv*  (LSJ)
#		: 11/02/2005 - Added ???-T-X12-ERR  (LSJ)
#		: 02/20/2006 - Added remove of SUSPWRKMAS-T  (LSJ)
#		: 03/09/2006 - Addition of claim109 files  (LSJ)
#		: 04/25/2006 - Added removal of X12 tape files  (LSJ)
#		: 08/17/2006 - Changed remove of xp inv files  (LSJ)
#               : 09/27/2006 - Added "-follow" to find commands  (LSJ)
#		: 10/18/2006 - Addition of JJHC files  (LSJ)
#		: 05/22/2007 - Changed *CL44-367369-T to *CL44-*-T  (LSJ)
#		: 06/04/2007 - Changes for new *CL130-T-AHF* files  (LSJ)
#		: 06/06/2007 - Changed ${CLAIM130KEY} to ${CLAIM130KEY}-T  (LSJ)
#		: 07/02/2007 - Added files for AHF claim109  (LSJ)
#		: 01/04/2008 - Added tape and key files from claim111rx  (LSJ)
#		: 03/27/2008 - Added /usr/lnk/misc/*CL58-T
#		: 06/02/2008 - Changes to include new JHS CL111 file  (LSJ)
#		: 03/17/2009 - Added claim109qtm files  (LSJ)
#		: 04/02/2009 - Removed claim12 and limit48 files  (LSJ)
#		: 05/11/2009 - Added misc pdf files
#		: 09/18/2009 - Changes for switch to new check run process
#		: 02/02/2010 - Added "OH" tapes files  (LSJ)
#		: 11/18/2010 - Changes for AHF switch to tweek-cycle
#		: 11/07/2011 - Added ???CL111D0-T-*
#		: 11/29/2011 - Added benovations related files
#		: 01/05/2012 - Remining D.0 file name changes; removed PREFIX logic
#		: 09/24/2012 - Added RXEOB reversals file
#		: 01/22/2013 - Added claim111rx files
#		: 02/20/2013 - Added EBA files
#		: 09/18/2013 - Added misc PDF files
#		: 11/19/2013 - added claim130 files
#		: 04/15/2014 - Add LVHN clmrt files
#		: 1/1/2015 - ODMH terminate
#               : 01/19/2015 - Added CLMRTCF files (TT #12337-11)
#               : 05/12/2015 - Added claim109d0 file (TT:13528-1)
#		: 08/24/2015 - TT:13604-27; add CLMRTHM files
#		: 01/12/2016 - add ???CL16-SYS-INVTOT-T
#               : 02/08/2017 - TT16831-5; logic for CLMRTHR (sys0181) files.
#               : 07/26/2017 - TT17250-2; logic for CLMRTCN (sys0183) files.
#		: 07/31/2018 - TT13915-66; RXFL files.
#		: 02/07/2019 - Add clmrt01 "DM" and "FV" files
#		: 05/19/2020 - Add clmrt01 for "RM" APRXMBEN files
#		: 08/03/2020 - add clmrt01 files for "PS" PSI
#               : 11/06/2020 - TT20826-1; AME ("me") clmrt01 files
#               : 11/06/2020 - TT20930-2; HWF ("hw") clmrt01 files
#		: 09/09/2021 - New clmrt01 files for: APO, HPS, BPS
#		: 10/04/2021 - New clmrt01 files for BPSCPS
#               : 01/10/2023 - New 2023 clmrt01 files: PAYSN, HWFD, FVFNDP
#		: 02/14/2023 - New BLRX clmrt01 files
#               : 08/29/2023 - Add EVOTEXT files
#               : 03/18/2024 - Add new Eversana ("EV") clmrt01 files
#               : 02/17/2025 - Removed claim130/claim109gran associated files
#               : 02/01/2026 - Add step to remove CLMRT refresh file for client cy
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
RXEOB_DIR="/usr/lnk/rxeob"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rm-twice.sh 

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
find sys???? -follow -name "*CL1[6-7]?-T*" -exec rm {} \;
echo "po reports files are removed"
rm -f ${MISC_DIR}/???CL16-SYS-INV-T
rm -f ${MISC_DIR}/???CL16-SYS-INVTOT-T
rm -f ${MISC_DIR}/*CL68-T
rm -f ${MISC_DIR}/*PRINT-CL16-T
rm -f ${MISC_DIR}/twice-PRINT-CLAIM59-CYCLE-T
echo "misc files are removed"
find /usr/lnk/xp -follow -name "inv-t-*" -exec rm {} \;
echo "xp files are removed"
rm ${GRP_DIR}/SUSPWRKMAS-T
rm ${GRP_DIR}/INLGWRKMAS-T
rm -f ${RXEOB_DIR}/pdmi_reversals_cycle_t_*.txt

rm ${TAPE_DIR}/????CLMRTBE
rm ${TAPE_DIR}/????BETEXT
rm ${TAPE_DIR}/????CLMRTTRCD
rm ${TAPE_DIR}/????TRCDTEXT
rm ${TAPE_DIR}/????CLMRTOH
rm ${TAPE_DIR}/????OHTEXT
rm ${TAPE_DIR}/????CLMRTWSN
rm ${TAPE_DIR}/????WSNTEXT
rm ${TAPE_DIR}/????CLMRTTL
rm ${TAPE_DIR}/????TLTEXT
rm ${TAPE_DIR}/????CLMRTCF
rm ${TAPE_DIR}/????CFTEXT
rm ${TAPE_DIR}/????CLMRTHM
rm ${TAPE_DIR}/????HMTEXT
rm ${TAPE_DIR}/????CLMRTCN
rm ${TAPE_DIR}/????CNTEXT
rm ${TAPE_DIR}/????CLMRTRXFL
rm ${TAPE_DIR}/????RXFLTEXT
rm ${TAPE_DIR}/????CLMRTDM
rm ${TAPE_DIR}/????DMTEXT
rm ${TAPE_DIR}/????CLMRTFV
rm ${TAPE_DIR}/????FVTEXT
rm ${TAPE_DIR}/????CLMRTRM
rm ${TAPE_DIR}/????RMTEXT
rm ${TAPE_DIR}/????CLMRTPS
rm ${TAPE_DIR}/????PSTEXT
rm ${TAPE_DIR}/????CLMRTME
rm ${TAPE_DIR}/????METEXT
rm ${TAPE_DIR}/????CLMRTHW
rm ${TAPE_DIR}/????HWTEXT
rm ${TAPE_DIR}/????CLMRTCS
rm ${TAPE_DIR}/????CSTEXT
rm ${TAPE_DIR}/????CLMRTAP
rm ${TAPE_DIR}/????APTEXT
rm ${TAPE_DIR}/????CLMRTBL
rm ${TAPE_DIR}/????BLTEXT
rm ${TAPE_DIR}/????CLMRTBC
rm ${TAPE_DIR}/????BCTEXT
rm ${TAPE_DIR}/????CLMRTBO
rm ${TAPE_DIR}/????BOTEXT
rm ${TAPE_DIR}/????CLMRTBN
rm ${TAPE_DIR}/????BNTEXT
rm ${TAPE_DIR}/????CLMRTBX
rm ${TAPE_DIR}/????BXTEXT
rm ${TAPE_DIR}/????CLMRTVS
rm ${TAPE_DIR}/????VSTEXT
rm ${TAPE_DIR}/????CLMRTGX
rm ${TAPE_DIR}/????GXTEXT
rm ${TAPE_DIR}/????CLMRTPN
rm ${TAPE_DIR}/????PNTEXT
rm ${TAPE_DIR}/????CLMRTBK
rm ${TAPE_DIR}/????BKTEXT
rm ${TAPE_DIR}/????CLMRTWD
rm ${TAPE_DIR}/????WDTEXT
rm ${TAPE_DIR}/????CLMRTFC
rm ${TAPE_DIR}/????FCTEXT
rm ${TAPE_DIR}/????CLMRTEV
rm ${TAPE_DIR}/????EVTEXT
rm ${TAPE_DIR}/????CLMRTCY
rm ${TAPE_DIR}/????CYTEXT
rm ${TAPE_DIR}/???CL111D0-T-*
rm ${TAPE_DIR}/???CL111RX-T-RXEOB
rm ${TAPE_DIR}/???-T-RXEOBTEXT

parse_env

rm ${CLAIM68KEY}-T
rm ${CLAIM46KEY}-T
rm ${CLAIM47KEY}-T
rm ${CLAIM16KEY}-T
rm ${CLAIM55KEY}-T
rm ${REVER03KEY}-T
rm ${CLMRT01KEY}-T
rm ${CLAIM111KEY}-D0-T
rm ${CLAIM111RXKEY}-T 


rm ${RPT_DIR}/twice-*


exit 0
