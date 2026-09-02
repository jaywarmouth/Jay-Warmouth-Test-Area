#!/bin/sh
#
# Program Name	: cp_audit.sh
# Description	: Copy audit files from remote system and rename them
# Version	: 3.0
# Date		: 06/15/2018
#
# Variables Used:
#PROD_MACHINE="prod10"
#BACKUP_MACHINE="prod20"
PROD_MACHINE="${PROD_SERVER}"
BACKUP_MACHINE="${BACKUP2_SERVER}"
AUD_DIR="/usr/lnk/audit"
SW16="/usr/lnk/daily/switch16"
SW40="/usr/lnk/daily/switch40"
DATE=`date +%Y%m%d`
AUDIT_PREFIX="AUDIT-"
MSG_PREFIX="MSG-"
CLMSS_PREFIX="CLMSS-"
EFSS_PREFIX="EFSS-"
SCSS_PREFIX="SCSS-"
FVSS_PREFIX="FVSS-"
AUDIT_NUMS="200 201 300 301 400 402 404 406 408"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cp_audit.sh 

ENDOFUSAGE
  exit 1
}

cp_backup()
{
for number in `echo $AUDIT_NUMS`
do
	scp ${BACKUP_MACHINE}:${AUD_DIR}/${PREFIX}${number}-${DATE} ${AUD_DIR}/${PREFIX}${number}-${DATE}.${BACKUP_MACHINE}
done
}


#
# Main routine
#

# Check command line validity, call usage if incorrect

if [ $# -ne 0 ] 
then
  usage
fi

HOSTNAME=`/usr/lnk/shell/get_hostname.sh`

if [ ${HOSTNAME} = ${BACKUP_MACHINE} ]
then
  echo "-*> You are on the wrong system"
  exit 1
fi


PREFIX="${AUDIT_PREFIX}"
cp_backup
PREFIX="${MSG_PREFIX}"
cp_backup
PREFIX="${CLMSS_PREFIX}"
cp_backup
PREFIX="${EFSS_PREFIX}"
cp_backup
PREFIX="${SCSS_PREFIX}"
cp_backup
PREFIX="${FVSS_PREFIX}"
cp_backup

if [ ${HOSTNAME} = "prod10" ]
then
	ssh -q ${BACKUP_MACHINE} "/usr/lnk/shell/cp_clmrt_files.sh"
	scp ${BACKUP_MACHINE}:${SW16}/switch16-${DATE} ${SW16}/switch16-${DATE}.${BACKUP_MACHINE}
	scp ${BACKUP_MACHINE}:${SW40}/switch40-${DATE} ${SW40}/switch40-${DATE}.${BACKUP_MACHINE}
fi

exit 0
