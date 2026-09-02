#!/bin/bash
#

TR_PROG="/usr/lnk/shell/secure_transfer.sh"
X12_DIR=/usr/lnk/wt/pdmi-pbm-prod/process/section111/pdmi/834-inbound/raw
CARDH29_DIR=/usr/lnk/wt/pdmi-pbm-prod/section111-process/000056349/client-data/eligibility/cardh29-inbound



# GoAnywhere transfer
transfer_files() {
	local dir=$1
	local trid=$2
	find ${dir} -follow -type f -mmin +1 > /tmp/section111-filelist.txt
	for file in `cat /tmp/section111-filelist.txt`; do
		${TR_PROG} $trid $file
		if test $? -eq 0
		then
			rm -f $file
		fi
	done
}

date

# Cardh29 files
transfer_files ${CARDH29_DIR} Section111CA29

# X12 Files
transfer_files ${X12_DIR} Section111X12

date
