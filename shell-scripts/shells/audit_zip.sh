#!/bin/sh
#
# Program Name	: audit_zip.sh
# Description   : zips previous day's AUDIT file and compresses all *AUD files
# Author	: Linda S. Jefferis
# Date		: 03/29/96
# Modifications : 
#		: 03/28/2018 - TT18207-21; SCSS audit files
#		: 04/19/2022 - remove "prod20" logic.
#		: 05/27/2022 - replace 404 with 410
#                 01/31/2022 - Removed "BACKUP_2/husk" logic.
#		: 03/2024 - Add logic for new switch company (700/701)
#		: 03/2024 - Add logic for new switch company (900/901)
#
# Variables Used:
DATE=`date -d "yesterday 0800" +%Y%m%d`
TODAY=`date +%Y%m%d`
PROD_DIR="/usr/lnk/audit"
BACKUP_1="prod11"
BACKUP_5="prodtest10"
BACKUP_DIR=/usr/lnk/audit

# Load the configuration file
CONFIG_FILE="/usr/local/etc/claim96.conf"
if [[ -f $CONFIG_FILE ]]; then
    source $CONFIG_FILE
else
    echo "Configuration file $CONFIG_FILE not found."
    exit 1
fi

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage:  audit_zip.sh

ENDOFUSAGE
  exit 1
}

# scp file process
scp_files() {
    local prefix=$1
    local numbers=("${!2}")
    local count=$3

    for ((i=0; i<count; i++)); do
        local filename="${prefix}-${numbers[i]}-${DATE}"
	if [[ -f ${PROD_DIR}/${filename} ]]; then
		scp -q ${PROD_DIR}/${filename} ${BACKUP_1}:${BACKUP_DIR}/${filename}.cmp
		if test $? -ne 0
		then
        		echo ""
        		echo "-*> scp of ${filename} to ${BACKUP_1} was unsuccessful"
		fi
		scp -q ${PROD_DIR}/${filename} ${BACKUP_5}:${BACKUP_DIR}/${filename}.cmp
		if test $? -ne 0
		then
        		echo ""
        		echo "-*> scp of ${filename} to ${BACKUP_5} was unsuccessful"
		fi
	else
		echo "${PROD_DIR}/${filename} does not exist"
	fi
    done
}


#
# Main routine
#


if ! test -a ${PROD_DIR}/DMR-${TODAY}
then
   touch ${PROD_DIR}/DMR-${TODAY}
   chmod 666 ${PROD_DIR}/DMR-${TODAY}
fi

# SCP DMR file
if [[ -f ${PROD_DIR}/DMR-${DATE} ]]; then
	scp -q ${PROD_DIR}/DMR-${DATE} ${BACKUP_1}:${BACKUP_DIR}/DMR-${DATE}.cmp
	if test $? -ne 0
	then	
		echo ""
		echo "-*> scp of DMR-${DATE} to ${BACKUP_1} was unsuccessful"
	fi
	scp -q ${PROD_DIR}/DMR-${DATE} ${BACKUP_5}:${BACKUP_DIR}/DMR-${DATE}.cmp
	if test $? -ne 0
	then	
		echo ""
		echo "-*> scp of DMR-${DATE} to ${BACKUP_5} was unsuccessful"
	fi
else
	echo "${PROD_DIR}/DMR-${DATE} does not exist"
fi

# SCP regular audit files
scp_files "AUDIT" QNUMBERS[@] $QCOUNT

# SCP CLMSS files
scp_files "CLMSS" QNUMBERS[@] $QCOUNT

# SCP MSG files
scp_files "MSG" QNUMBERS[@] $QCOUNT

# SCP EFSS files
scp_files "EFSS" QNUMBERS[@] $QCOUNT

# SCP SCSS files
scp_files "SCSS" QNUMBERS[@] $QCOUNT


echo ""
echo "--> Schedule of daily_audit_check.sh script on BACKUP systems" 
ssh ${BACKUP_1} "echo "/usr/lnk/shell/daily_audit_check.sh" | at now +2 minutes"
ssh ${BACKUP_5} "echo "/usr/lnk/shell/daily_audit_check.sh" | at now +2 minutes"

exit 0
