#!/bin/sh
#
# Program Name	: daily_cardh78.sh
# Description	: Daily TrialCard CARDH78 Processing 
#		  Currently cardh78 
# Author	: Linda S. Jefferis
# Date		: 08/20/2012
# Modifications : TT:13915-7 add "-r" rerun option. This just flags to not schedule tr_cardh78.sh process.
#		: 03/10/2016 - TT13309-6
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/bin/mail"
MAIL_TO=operations@pdmi.com
CURR_DATE=`date +%Y%m%d`
DATE=`date -d "yesterday 0800" +%Y%m%d`
DAY=`date +%w`
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
FILE_DIR="/usr/lnk/tapes"
ARCH_DIR="/usr/lnk/elig_in/sys0078"
CARDH78_FILE="CARDH78TAP-${CURR_DATE}"
LOG="$RPT_DIR/daily_cardh78"
RERUN=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: daily_cardh78.sh 

ENDOFUSAGE
  exit 1
}

# Transferring file to remote server
cp_file()
{
echo "--> Converting and transferring file on Remote" >> ${LOG}
if test -s ${FILE_DIR}/${FILE}
then
        touch ${FILE_DIR}/${FILE}.done
	scp ${FILE_DIR}/${FILE} ${REMOTE_SYS}:${REMOTE_DIR}
        scp ${FILE_DIR}/${FILE}.done ${REMOTE_SYS}:${REMOTE_DIR}
	if [ ${RERUN} = 0 ]
	then
		ssh ${REMOTE_SYS} "echo "${TR_SCRIPT}" | at 12:15pm today"
	fi
        echo "File archived to ${ARCH_DIR}" >> ${LOG}
        mv ${FILE_DIR}/${FILE} ${ARCH_DIR}
	rm -f ${FILE_DIR}/${FILE}.done
else
        echo "-*> No ${FILE} file..." >> ${LOG}
fi
}

#
# Main routine
#
while [ $# -gt 0 ]
do
  case "$1"
  in
    -r) RERUN=1
	;;
  esac
  shift
done

${SHELL_DIR}/cardh78.sh > ${LOG} 2>&1
FILE=${CARDH78_FILE}
TR_SCRIPT="${SHELL_DIR}/tr_cardh78.sh"
#TIME=`date +%M`
cp_file


cat ${LOG} | ${MAIL_PROG} -s "Daily cardh78 Processes" ${MAIL_TO}


exit 0
