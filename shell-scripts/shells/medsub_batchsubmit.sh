#!/bin/sh
#
# Program Name	: medsub_batchsubmit.sh
# Description	: Script to run the medsub batchsubmit process
# Author	: Linda S. Jefferis
# Date		: 03/06/2013
# Modification	: 01/31/2016 - Change data_q and traffic_q numbers
#		: 04/13/2018 - Change file locations
#
# Variables Used:
DATE=`date +%Y%m%d`
DATETM=`date +%Y%m%d%H%M%S`
RPT_DIR="/usr/lnk/rpt"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="operations@pdmi.com"
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
NCPDPIN="/usr/lnk/wt/oper-wt/MEDSUB/HMS/In"
RSPFILE="/usr/lnk/wt/oper-wt/MEDSUB/HMS/FromPDMI/resp"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: medsub_batchsubmit.sh

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

cd ${NCPDPIN}
ls -1 TRB*.*.txt > /tmp/medsub-filelist.txt
for file in `cat /tmp/medsub-filelist.txt`
do
	/usr/local/bin/batchsubmit -d 100 520 408 ${NCPDPIN}/$file ${RSPFILE}/medsub_resp.$file >> ${RPT_DIR}/medsub_batchsubmit_${DATETM} 2>&1
done

cat ${RPT_DIR}/medsub_batchsubmit_${DATETM} | ${MAIL_PROG} -s "${HOSTNAME} - MEDSUB Batchsubmit" ${MAIL_TO}

exit 0
