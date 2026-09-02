#!/bin/sh
#
# Program Name  : rm-pay.sh
# Description   : Removal of pay-cycle files
# Author        : Linda S. Jefferis
# Date          : 09/25/98
# Modifications : 11/16/99 - Added the remove of files from claim116  (LSJ)
#		: 03/06/00 - Added CL44 and claim117 files  (LSJ)
#		: 03/14/00 - Added "SUSPWRKMAS"  (LSJ)
#		: 05/18/00 - Added "INLGWRKMAS"  (LSJ)
#		: 05/18/00 - Added SUMA-DED file  (LSJ)
#		: 05/18/00 - Changed rm of xp files  (LSJ)
#		: 05/22/00 - Added "*.PCX" files  (LSJ)
#		: 06/30/00 - Added *CL08* files  (LSJ)
#		: 11/14/00 - Added ???LIM12* files  (LSJ)
#		: 11/24/00 - Changed CHECK00WRK.cycle CHKWRK and added CLAIMS_DIR  (LSJ)
#		: 02/13/01 - Added CLAIM109 tape files and key  (LSJ)
#		: 04/03/01 - Added CL113 and CL119 files  (LSJ)
#		: 04/03/01 - Deleted CL109 files  (LSJ)
#		: 05/18/01 - Added CL113 and CL119 TEXT files  (LSJ)
#		: 06/13/01 - Readded CL109 files  (LSJ)
#		: 06/13/01 - Added CL94 tape and key files  (LSJ)
#		: 08/16/01 - Changed grp and claims path to /usr/upd  (LSJ)
#		: 09/12/01 - Added *MKTINV and *MKTDET files  (LSJ)
#		: 02/07/02 - Added ???CL08UHMO  (LSJ)
#		: 04/25/02 - Added new Rented Network files  (LSJ)
#		: 07/02/02 - Misc. changes  (LSJ)
#		: 08/22/02 - Changed MKTDET to INV02.L7  (LSJ)
#		: 05/29/03 - Added rm of rpt files  (LSJ)
#		: 12/18/03 - Addition of CL127-TOTALS and ???CL07-ZEROCHK (LSJ)
#		: 12/19/03 - Addition of claim123 report files and key file  (LSJ)
#		: 01/29/04 - Changes for two separate CLAIM70 key files  (LSJ)
#		: 01/29/04 - Addition of CL109KIN and CL109IBA files  (LSJ)
#		: 01/29/04 - Addition of *CL128* report and key files  (LSJ)
#		: 02/17/04 - Changed the inv???? and invb???? to a inv*  (LSJ)
#		: 03/19/04 - Changed CL111SUMA to CL111RXEOB  (LSJ)
#		: 04/06/2004 - Changes for CL44 filename change  (LSJ)
#		: 04/29/2004 - Addition of some CL109 tape and text files  (LSJ)
#		: 08/12/2004 - Addition of claim124 and claim130 files  (LSJ)
#		: 10/04/2004 - Addition of more CL109 tape files  (LSJ)
#		: 11/26/2004 - Added *CHPTEXT file  (LSJ)
#		: 12/30/2004 - Changes for newcycle filenames  (LSJ)
#		: 02/03/2005 - Addition of PRINT-CLAIM59-CYCLE-P  (LSJ)
#		: 02/03/2005 - Fixed CL128  (LSJ)
#		: 05/09/2005 - Changes for new KEY file names  (LSJ)
#		: 06/08/2005 - Name changes for CL111 tape files  (LSJ)
#		: 07/29/2005 - Fixed CL128Z-P.REJ  (LSJ)
#		: 08/09/2005 - Addition of ABC tapes files  (LSJ)
#		: 11/08/2005 - Addition of ???-P-X12-ERR"  (LSJ)
#		: 02/13/2006 - Change name of CLAIM109KEY  (LSJ)
#		: 02/20/2006 - Changed SUSPWRKMAS to SUSPWRKMAS-P  (LSJ)
#		: 04/25/2006 - Added removal of X12 tapes (LSJ)
#		: 04/26/2006 - Added removal of claim111 HRMB files  (LSJ)
#		: 05/30/2006 - General cleanup  (LSJ)
#		: 08/17/2006 - Changed remove of xp files  (LSJ)
#               : 09/27/2006 - Added "-follow" to find commands  (LSJ)
#		: 10/09/2006 - Changes for 4-digit sys#  (LSJ)
#		: 01/11/2007 - Removed claim120 and invoice02 related files (LSJ)
#		: 02/19/2007 - Added "BEA" tape files  (LSJ)
#		: 03/20/2007 - Added WBS and AGMC tapes files  (LSJ)
#		: 06/06/2007 - Changed ${CLAIM130KEY} to ${CLAIM130KEY}-P  (LSJ)
#		: 07/19/2007 - Had ???SUMA-DED-P wrong
#		: 08/15/2007 - Removed PCX, CL124, CLAIM106KEY, and CLAIM124KEY files  (LSJ)
#		: 01/04/2008 - Added tape and key files from claim111rx  (LSJ)
#		: 01/04/2008 - Addition of files for claim109eb and WGHD files  (LSJ)
#		: 01/29/2008 - Addition of CCAI claim117 file  (LSJ)
#		: 04/25/2008 - Changed WGHD files to MBI files  (LSJ)
#		: 08/19/2008 - changed CL44 filename  (LSJ)
#		: 09/10/2008 - Added CL109 MBM files  (LSJ)
#		: 11/10/2008 - Added claim132 files  (LSJ)
#		: 01/02/2009 - Took out the remove of CL106 TEXT file  (LSJ)
#		: 03/19/2009 - Added claim133 files  (LSJ)
#		: 05/11/2009 - Added pdf files
#		: 09/06/2009 - /usr/lnk/tapes/BAS files  (LSJ)
#		: 09/23/2009 - Changes for switch to new check run process
#		: 01/27/2010 - Added clmrt01 files for Assist Rx
#		: 06/01/2010 - Changed some "tapes" removal
#		: 07/02/2010 - Added "?" to RXEOB file names
#		: 07/22/2010 - Removed extra "?" for RXEOB files
#		: 08/31/2010 - Added files for new clncpdp01 process
#		: 11/02/2010 - Added ftp-tmp files and email logic
#		: 02/02/2011 - Added files for new claim109gran process
#		: 06/30/2011 - Added files for claim109d0 process
#		: 09/21/2011 - Added PRM_Retail-Mail-Report
#		: 09/24/2012 - Added RXEOB reversal file
#		: 01/28/2013 - Removed files for claim109gran process (DME)
#		: 07/12/2013 - Added back files for NCYP claims09gran
#		: 07/16/2013 - Added clmrt01 files for MF and cleanup
#		: 09/09/2013 - Added URX-Differentials-*.zip
#		: 05/06/2014 - Added 71inv_sum files
#               : 01/20/2015 - Remove CCAI/claim117 files (TT #12717-2)
#               : 01/20/2015 - Add "IB" clmrt files
#               : 02/02/2015 - Due to term of sys0052 and sys0071, remove rented network related procedures. (TT #12718-2, #12713-2).
#		: 01/12/2016 - Add ???CL16-SYS-INVTOT-P, remove PREFIX logic, and misc. cleanup items.
#		: 05/11/2016 - TT15163-5; claim109hcrm files
#               : 08/08/2017 - TT13915-53; removal of claim109eb and claim132 related files.
#               : 09/21/2018 - Removal of claim109d0 related files
#		: 05/29/2019 - TT13915-84; removal of claim123 files and other cleanup.


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
MAIL_PROG="/bin/mail"
MAIL_TO="operations@pdmi.com"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rm-pay.sh 

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
find sys???? -follow -name "*CL1[6-7]?-P*" -exec rm {} \;
echo "*CL16* and *CL17* are removed"
find sys???? -follow -name "SUSP.S??" -exec rm {} \;
echo "SUSP.S?? are removed"
rm -f ${MISC_DIR}/*CL16-SYS-INV-P
rm -f ${MISC_DIR}/*CL16-SYS-INVTOT-P
rm -f ${MISC_DIR}/*CL68-P
rm -f ${MISC_DIR}/*PRINT-CL16-P
rm -f ${MISC_DIR}/pay-PRINT-CLAIM59-CYCLE-P
echo "misc files are removed"
find /usr/lnk/xp -follow -name "invb*" -exec rm {} \;
echo "xp files are removed"
rm ${TAPE_DIR}/???CL111RX-P-RXEOB
rm ${TAPE_DIR}/???-P-RXEOBTEXT
rm ${TAPE_DIR}/???CL111D0-P-*
rm ${TAPE_DIR}/???CL130-P-*

rm ${GRP_DIR}/SUSPWRKMAS-P
rm ${GRP_DIR}/INLGWRKMAS-P

rm -f ${RXEOB_DIR}/pdmi_reversals_cycle_p_*.txt

parse_env

rm ${CLAIM68KEY}-P
rm ${CLAIM46KEY}-P
rm ${CLAIM47KEY}-P
rm ${CLAIM16KEY}-P
rm ${CLAIM111RXKEY}-P
rm ${CLAIM111KEY}-D0-P
rm ${CLAIM130KEY}-P
rm ${CLAIM55KEY}-P
rm ${REVER03KEY}-P

rm ${RPT_DIR}/pay-*



exit 0
