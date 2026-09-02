#!/bin/sh
#
# Program Name	: daily_rt_clms.sh
# Description	: Daily Real Time Claims File Copies for Clients 
#		  -c <clientid>	if this option not used, defaults to ALL
#		  -d <ccyymmdd>    For rerun of a specific prior day
#		: 04/08/2022 - add TRVS ("vs") sys0209 Truveris logic.
#		: 04/19/2022 - removed 'check_for_backup_files' logic
#		: 11/15/2022 - added PAYSN ("pn") file logic.
#		: 11/15/2022 - added FVFNDP ("fc") file logic.
#		: 11/28/2022 - added HWFD ("wd") file logic.
#		: 11/30/2022 - remove terminated APRXMBEN ("rm") file logic.
#		: 02/14/2023 - added BLRX ("bk"; sys0219) file logic.
#		: 05/02/2023 - Changed logic for MEDBEN files and "upload_files logic for new SFTP acct
#		: 03/07/2024 - Add logic for EVER ("ev") sys0223/EVERSANA
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO=operations@pdmi.com
FILE_DATE=`date -d "yesterday 0800" +%Y%m%d`
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
WT_DIR="/usr/lnk/wt/oper-wt/sftpexport"
DAILY_DIR="DailyFile/ToDE"
LOG="$RPT_DIR/daily_rt_clms"
TR_PROG="/usr/lnk/shell/secure_transfer.sh"
CLEANUP_SCRIPT="/usr/lnk/shell/cleanup.sh"
CONV_PROG="/usr/local/bin/addlf"
REC_SIZE="1026"
SPEC_PROC=0
ERR=0
CLIENTID="all"
ZEROFILE_FLG=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_rt_clms.sh -r -c all|<clientid> -d <ccyymmdd>
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
DEST=NULL
NEW_FILE="Dailyclms-PAF-${FILE_DATE}.txt"
SPEC_PROC=1
ZEROFILE_FLG=1
TR_ID="PAF"
upload_file
echo `date` >> ${LOG}
}

# PAF-LLS (sys0185) File
ll_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/ll"
DEST=NULL
NEW_FILE="Dailyclms-LLS-${FILE_DATE}.txt"
SPEC_PROC=1
ZEROFILE_FLG=1
TR_ID="LLS"
upload_file
echo `date` >> ${LOG}
}

# PAF-BCH (sys0224) File
fb_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/fb"
DEST=NULL
NEW_FILE="Dailyclms-BCH-${FILE_DATE}.txt"
SPEC_PROC=1
ZEROFILE_FLG=1
TR_ID="BCH"
upload_file
echo `date` >> ${LOG}
}

# PAF-RMA/MAP (sys0225) File
ci_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/ci"
DEST=NULL
NEW_FILE="Dailyclms-MAP-${FILE_DATE}.txt"
SPEC_PROC=1
ZEROFILE_FLG=1
TR_ID="MAP"
upload_file
echo `date` >> ${LOG}
}

# PAF-HOPE/HCM (sys0226) File
cm_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/cm"
DEST=NULL
NEW_FILE="Dailyclms-HCM-${FILE_DATE}.txt"
SPEC_PROC=1
ZEROFILE_FLG=1
TR_ID="HCM"
upload_file
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
DEST=${WT_DIR}/FVF/FromPDMI
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
DEST=${WT_DIR}/FVFNDP/FromPDMI
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
DEST=${WT_DIR}/PSI/${DAILY_DIR}
NEW_FILE="Dailyclms-PSI-${FILE_DATE}.txt"
copy_file
echo `date` >> ${LOG}
}

# APO (sys0205) File
ap_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/ap"
DEST=${WT_DIR}/APO/${DAILY_DIR}
NEW_FILE="Dailyclms-APO-${FILE_DATE}.txt"
copy_file
echo `date` >> ${LOG}
}

# AME (Ametros-sys0198) File
me_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/me"
DEST=${WT_DIR}/AMETROS/${DAILY_DIR}
NEW_FILE="Dailyclms-AME-${FILE_DATE}.txt"
copy_file
echo `date` >> ${LOG}
}

# Healthwell (sys0175) File
hw_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/hw"
DEST=${WT_DIR}/HWELL/${DAILY_DIR}
NEW_FILE="Dailyclms-HWELL-${FILE_DATE}.txt"
copy_file
echo `date` >> ${LOG}
}

# HWF-Direct (sys0212) File
wd_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/wd"
DEST=${WT_DIR}/HWFD/${DAILY_DIR}
NEW_FILE="Dailyclms-HWFD-${FILE_DATE}.txt"
copy_file
echo `date` >> ${LOG}
}

# AssistRx (sys0166) File
ax_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/ax"
DEST=${WT_DIR}/ARX/${DAILY_DIR}
NEW_FILE="Dailyclms-ARX-${FILE_DATE}.txt"
copy_file
echo `date` >> ${LOG}
}

# TRVS (Truveris-sys0209)
vs_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/vs"
DEST=${WT_DIR}/TRVS/${DAILY_DIR}
NEW_FILE="Dailyclms-TRVS-${FILE_DATE}.txt"
copy_file
echo `date` >> ${LOG}
}

# EVER (Eversana-sys0223)
ev_process()
{
set_filenames
FILE_DIR="/usr/lnk/daily/ev"
DEST=${WT_DIR}/EVER/${DAILY_DIR}
NEW_FILE="Dailyclms-EVER-${FILE_DATE}.txt"
copy_file
echo "Special TEMP copy of file to /usr/lnk/wt/jwarmouth location"
cp ${FILE_DIR}/${CLM_FILE} /usr/lnk/wt/jwarmouth/${NEW_FILE}
echo `date` >> ${LOG}
}

#
# Upload File
upload_file()
{
	if test -s ${FILE_DIR}/${CLM_FILE}
	then
                case ${SPEC_PROC} in
                   "0")
                        cp ${FILE_DIR}/${CLM_FILE} /tmp/${NEW_FILE}
                        ;;
                   "1")
                        ${CONV_PROG} ${REC_SIZE} ${FILE_DIR}/${CLM_FILE} /tmp/${NEW_FILE}
                        ;;
                esac
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
                        cp ${FILE_DIR}/${CLM_FILE} ${DEST}/${NEW_FILE}
                        ;;
                   "1")
                        ${CONV_PROG} ${REC_SIZE} ${FILE_DIR}/${CLM_FILE} /tmp/${CLM_FILE}
                        cp /tmp/${CLM_FILE} ${DEST}/${NEW_FILE}
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
           cp ${FILE_DIR}/${CLM_FILE} ${DEST}/${NEW_FILE}
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
        mb_process
	xm_process
	hm_process
	pa_process
	ll_process
	fb_process
	ci_process
	cm_process
	dm_process
	fv_process
	fc_process
#	ps_process
#	me_process
#	hw_process
#	wd_process
#	ap_process
#	ax_process
#	vs_process
#	ev_process
        ;;
     *) 
	${CLIENTID}_process
	;;
esac

cat ${LOG} | ${MAIL_PROG} -s "Daily RealTime Claims Process" ${MAIL_TO}


exit 0
