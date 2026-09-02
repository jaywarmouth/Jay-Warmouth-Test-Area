#!/bin/sh
#
# Script renames excel file provided from RS and encrypts/uploads file to sis-ftp/FromPDMI. Email notification is handled by sis-ftp entry in FiTS Manager.


RPTNAME=$1
RPT_DIR="/usr/lnk/wt/oper-wt/week"
DATE=`date +%Y%m%d`
TR_ID="SISCO"

mv ${RPT_DIR}/${RPTNAME} ${RPT_DIR}/${DATE}_${RPTNAME}
if test $? -ne 0
then
	echo "-*> Unable to rename file."
	exit 1
fi
/usr/lnk/shell/secure_transfer.sh ${TR_ID} ${RPT_DIR}/${DATE}_${RPTNAME}
if test $? -ne 0
then
	echo "-*> Error with transfer of ${RPT_DIR}/${DATE}_${RPTNAME} to sis-ftp/FromPDMI"
	exit 1
fi
rm -f ${RPT_DIR}/${DATE}_${RPTNAME}

exit 0
