#!/bin/sh
#
# Program Name	: daily_rt_clms_goany.sh
# Description	: Daily Real Time Claims File Copies for Clients 
#		  -c <clientid>	if this option not used, defaults to ALL
#		  -d <ccyymmdd>    For rerun of a specific prior day
# Author	: Linda S. Jefferis
# Date		: 06/08/2009
#		: 05/19/2020 - TT20251-11; add APRXMBEN ("rm") logic.
#		: 08/03/2020 - add PSI ("ps") sys0197 logic.
#		: 11/06/2020 - add logic for AME ("me") and PARTIAL but NOT active yet logic for HWELL ('hw")
#		: 12/04/2020 - removed logic for "ar" (sys0123); "ax" (sys0166); "rp ("sys0180)
#		: 12/21/2020 - added the hw_process command.
#		: 06/01/2021 - added new logic for "ax" (sys0166) and "cs" (all HPS-CareServices)
#		: 06/01/2021 - updated logic for "cf" (sys0171) and "cn" (sys0183)
#		: 09/01/2021 - add APO ("ap") sys0205 ApolloRx logc.
#		: 09/15/2021 - added first set of BPS files (bl,bc,bo,bn)
#		: 10/04/2021 - added new BPSCPS ("bx") file
#		: 10/11/2021 - Enabled the new "ax" logic.
#		: 04/08/2022 - add TRVS ("vs") sys0209 Truveris logic.
#		: 04/19/2022 - removed 'check_for_backup_files' logic
#		: 11/15/2022 - added PAYSN ("pn") file logic.
#		: 11/15/2022 - added FVFNDP ("fc") file logic.
#		: 11/28/2022 - added HWFD ("wd") file logic.
#		: 11/30/2022 - remove terminated APRXMBEN ("rm") file logic.
#		: 02/14/2023 - added BLRX ("bk"; sys0219) file logic.
#		: 05/02/2023 - Changed logic for MEDBEN files and "upload_files logic for new SFTP acct
#               : 01/14/2026 - added CCAF CancerCareAF ("cy") client file.
#		: 03/16/2026 - Adding LCOPAY ("lc"), LSUN ("ls"), LGSK (gk") HALO: 90780
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO=operations@pdmi.com
FILE_DATE=`date -d "yesterday 0800" +%Y%m%d`
LOG="$RPT_DIR/daily_rt_clms"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="1026"
SPEC_PROC=0
ERR=0
CLIENTID="all"
ZEROFILE_FLG=0
AWS_CP="/usr/local/bin/aws s3 cp"
AWS_MV="/usr/local/bin/aws s3 mv"
WT_DIR="s3://ga-internal-transfers"
DAILY_DIR="OUTBOUND/claims-daily"
COUNT_FILE=/tmp/Dailyclms_COUNT_${FILE_DATE}.txt
DEST_CNTFILE="s3://ga-internal-transfers/PDMI/DATA-ENGINEERING/OUTBOUND/CLAIMS-DAILY-COUNTS/"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_rt_clms_goanyprod.sh -r -c all|<clientid> -d <ccyymmdd>
	Both options are optional and used for rerun purposes.

ENDOFUSAGE
  exit 1
}

# Set filenames
set_filenames()
{
	CLM_FILE="CLMRT-${FILE_DATE}"
	SPEC_PROC=0
	ZEROFILE_FLG=0
}

# Count File Process
countfile_proc()
{
ORIGFILE=$1
OUTNAME=$2
FILESIZE=$(ls -l ${ORIGFILE} | awk '{print $5}')
REC_CNT=$(( FILESIZE / REC_SIZE ))
echo "$OUTNAME|${REC_CNT}" >> ${COUNT_FILE}
}


# MedBen File
mb_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/mb"
DEST=NULL
NEW_FILE="MEDBEN_CLMS_${FILE_DATE}"
ZEROFILE_FLG=1
TR_ID="MEDB"
upload_file
echo `date` >> ${LOG}
}


# TrueScripts - MedBen File
xm_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/xm"
DEST=${WT_DIR}/TSCMBEN
NEW_FILE="Dailyclms-TSCMBEN-${FILE_DATE}.txt"
ZEROFILE_FLG=1
copy_file
echo `date` >> ${LOG}
}

# Current CDF (sys0171) File
cf_process()
{
# NEW CDF (sys0171) File
set_filenames
FILE_DIR="/usr/lnk/daily/cf"
DEST=${WT_DIR}/CDF/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-CDF-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# HMED (sys0173) File
hm_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/hm"
DEST=${WT_DIR}/hmed/FromPDMI
NEW_FILE="Dailyclms-HMED-${FILE_DATE}.txt"
SPEC_PROC=1
ZEROFILE_FLG=1
copy_file
echo `date` >> ${LOG}
}

# PAF (sys0176) File
pa_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/pa"
DEST=${WT_DIR}/PAF/FromPDMI
NEW_FILE="Dailyclms-PAF-${FILE_DATE}.txt"
SPEC_PROC=1
ZEROFILE_FLG=1
copy_file
echo `date` >> ${LOG}
}

# LLS (sys0185) File
ll_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/ll"
DEST=${WT_DIR}/LLS/FromPDMI
NEW_FILE="Dailyclms-LLS-${FILE_DATE}.txt"
SPEC_PROC=1
ZEROFILE_FLG=1
copy_file
echo `date` >> ${LOG}
}

# Current CDFCancerCare (sys0183) File
cn_process()
{
# NEW CDFCancerCare (sys0183) File
set_filenames
FILE_DIR="/usr/lnk/daily/cn"
DEST=${WT_DIR}/CDFCC/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-CDFCC-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# CompDME (sys0190) File
dm_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/dm"
DEST=/usr/lnk/wt/dme-00/FromPDMI
NEW_FILE="Dailyclms-CompDME-${FILE_DATE}.txt"
SPEC_PROC=1
ZEROFILE_FLG=1
copy_file
echo `date` >> ${LOG}
}

# FVF (sys0193) File
fv_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/fv"
DEST=${WT_DIR}/FVF/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-FVF-${FILE_DATE}.txt"
SPEC_PROC=1
ZEROFILE_FLG=1
copy_file
echo `date` >> ${LOG}
}

# FVFNDP (sys0211) File
fc_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/fc"
DEST=${WT_DIR}/FVF/NDP/${DAILY_DIR}
NEW_FILE="Dailyclms-FVFNDP-${FILE_DATE}.txt"
SPEC_PROC=1
ZEROFILE_FLG=1
copy_file
echo `date` >> ${LOG}
}

# PSI (sys0197) File
ps_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/ps"
DEST=${WT_DIR}/PSI/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-PSI-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# APO (sys0205) File
ap_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/ap"
DEST=${WT_DIR}/APO/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-APO-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# AME (Ametros-sys0198) File
me_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/me"
DEST=${WT_DIR}/AME/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-AME-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# Healthwell (sys0175) File
hw_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/hw"
DEST=${WT_DIR}/HWELL/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-HWELL-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# HWF-Direct (sys0212) File
wd_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/wd"
DEST=${WT_DIR}/HWFD/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-HWFD-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# AssistRx (sys0166) File
ax_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/ax"
DEST=${WT_DIR}/ARX/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-ARX-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# CareServices File (systems: 73,124,184,189)
cs_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/cs"
DEST=${WT_DIR}/CareServices/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-HPS-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# BPS-LTC (sys0201)
bl_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/bl"
DEST=${WT_DIR}/BPS/LTC/${DAILY_DIR}
NEW_FILE="Dailyclms-BPSLTC-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# BPS-COR (sys0202)
bc_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/bc"
DEST=${WT_DIR}/BPS/COR/${DAILY_DIR}
NEW_FILE="Dailyclms-BPSCOR-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# BPS-ODMH (sys0203)
bo_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/bo"
DEST=${WT_DIR}/BPS/ODMH/${DAILY_DIR}
NEW_FILE="Dailyclms-BPSODMH-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# BPS-NAPH (sys0204)
bn_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/bn"
DEST=${WT_DIR}/BPS/NAPH/${DAILY_DIR}
NEW_FILE="Dailyclms-BPSNAPH-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# BPS-CPS (sys0208)
bx_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/bx"
DEST=${WT_DIR}/BPS/CPS/${DAILY_DIR}
NEW_FILE="Dailyclms-BPSCPS-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# TRVS (Truveris-sys0209)
vs_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/vs"
DEST=${WT_DIR}/TRVS/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-TRVS-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# PAYSN (PaySign-sys0214)
pn_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/pn"
DEST=${WT_DIR}/PAYSN/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-PAYSN-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# BLRX (BlinkRx-sys0219)
bk_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/bk"
DEST=${WT_DIR}/BLRX/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-BLRX-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# EVER (Eversana-sys0223)
ev_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/ev"
DEST=${WT_DIR}/EVER/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-EVER-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

# Current CancerCareAF (sys0221) File
cy_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/cy"
DEST=${WT_DIR}/CCAF/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-CCAF-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}


#  LCOPAY Cencora (sys0120) File
lc_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/lc"
DEST=${WT_DIR}/LCOPAY/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-LCOPAY-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

#  LSUN Cencora (sys0132) File
ls_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/ls"
DEST=${WT_DIR}/LSUN/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-LSUN-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}

#  LGSK Cencora (sys0178) File
gk_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/gk"
DEST=${WT_DIR}/LGSK/DIR/${DAILY_DIR}
NEW_FILE="Dailyclms-LGSK-${FILE_DATE}.txt"
countfile_proc ${FILE_DIR}/${CLM_FILE} ${NEW_FILE}
copy_file
echo `date` >> ${LOG}
}


#
# Upload File
upload_file()
{
	if test -s ${FILE_DIR}/${CLM_FILE}
	then
		cp ${FILE_DIR}/${CLM_FILE} /tmp/${NEW_FILE}
	else
	   case ${ZEROFILE_FLG} in
	     "0")
		echo "--> Creating zero-byte file"  >> ${LOG}
		touch ${FILE_DIR}/${CLM_FILE}
		;;
	     "1")	
        	echo "--> Copying empty file to" >> ${LOG}
        	echo "No claims for today" > ${FILE_DIR}/${CLM_FILE}
		;;
	   esac
           chmod 666 ${FILE_DIR}/${CLM_FILE}
           cp ${FILE_DIR}/${CLM_FILE} /tmp/${NEW_FILE}
	fi

	echo "--> transferring file" >> ${LOG}
        ${TR_PROG} ${TR_ID} /tmp/${NEW_FILE} >> ${LOG}
	rm -f /tmp/${NEW_FILE}
}

#
# Copy File
copy_file()
{
	if test -s ${FILE_DIR}/${CLM_FILE}
        then
                echo "--> Copying file to ${DEST}" >> ${LOG}
                case ${SPEC_PROC} in
                   "0")
                        ${AWS_CP} ${FILE_DIR}/${CLM_FILE} ${DEST}/${NEW_FILE}
                        ;;
                   "1")
                        ${CONV_PROG} ${REC_SIZE} ${FILE_DIR}/${CLM_FILE} /tmp/${CLM_FILE}
                        ${AWS_CP} /tmp/${CLM_FILE} ${DEST}/${NEW_FILE}
                        rm -f /tmp/${CLM_FILE}
                        ;;
                esac
        else
           case ${ZEROFILE_FLG} in
             "0")
                echo "--> Creating/Copying zero-byte file to ${DEST}"  >> ${LOG}
                touch ${FILE_DIR}/${CLM_FILE}
                ;;
             "1")
                echo "--> Copying empty file to ${DEST}" >> ${LOG}
                echo "No claims for today" > ${FILE_DIR}/${CLM_FILE}
                ;;
           esac
           chmod 666 ${FILE_DIR}/${CLM_FILE}
           ${AWS_CP} ${FILE_DIR}/${CLM_FILE} ${DEST}/${NEW_FILE}
        fi
}	

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -c) shift
        if [ $# -le 0 ] 
        then
          usage   
        fi 
	CLIENTID=$1
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RERUN_DATE=$1
	FILE_DATE=`date -d "yesterday $RERUN_DATE 0800" +%Y%m%d`
        ;;
  esac
  shift
done

echo `date` > ${LOG}

case ${CLIENTID} in
   "all")
#       mb_process
#	xm_process
 	cf_process
#	hm_process
#	pa_process
#	ll_process
	cn_process
#	dm_process
#	fv_process
#	fc_process
	ps_process
	me_process
	hw_process
	wd_process
	ap_process
	ax_process
#	bl_process
#	bc_process
#	bo_process
#	bn_process
#	bx_process
	vs_process
	pn_process
	bk_process
	ev_process
        cy_process
        lc_process
        ls_process
        gk_process
        ;;
     *) 
	${CLIENTID}_process
	;;
esac

if [ -s ${COUNT_FILE} ]
then
	${AWS_CP} ${COUNT_FILE} ${DEST_CNTFILE}
	if [ $? -eq 0 ]
	then
		rm -f ${COUNT_FILE}
	else
		echo "The transfer of ${COUNT_FILE} failed" >> ${LOG}
	fi
fi
cat ${LOG} | ${MAIL_PROG} -s "Daily RealTime Claims PROD GoAnywhere Process" ${MAIL_TO}


exit 0
