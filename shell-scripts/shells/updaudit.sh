#!/bin/sh
#
# Program Name  : updaudit.sh 
# Description   : Updates audit files to CLAIM00MAS.
#                 Command line arguments:
#                 -r <remote system name>
#                 -now - Flag to skip "sleep 60" and run immediately
# Author        : Linda Jefferis
# Date          : 04/01/99
# Modifications : Various updates listed in the original script

# Variables
PATH=/usr/rmcobol:$PATH
REMOTE_DIR="/usr/lnk/audit"
HOST_DIR="/usr/lnk/audit"
SHELL_DIR="/usr/lnk/shell"
DATE=$(date +%Y%m%d)
CHK_CMD="ps -e | grep claim96"
CHK_RPT="/tmp/updaudit_chk"
HOST=$(/usr/lnk/shell/get_hostname.sh)
SUBJECT="$HOST updaudit"
MAILUSER="operator@pdmi.com"
ERR_MSG="Problem with updaudit.sh; claim96 already running"
NOW_FLAG=0
RPT_DIR=/usr/lnk/rpt

# Load the configuration file
CONFIG_FILE="/usr/local/etc/claim96.conf"
if [[ -f $CONFIG_FILE ]]; then
    source $CONFIG_FILE
else
    echo "Configuration file $CONFIG_FILE not found."
    exit 1
fi

# Usage routine
usage() {
    cat << ENDOFUSAGE

usage: updaudit.sh -r <remote system name> -now
    -r <system name> - required argument
    -now - optional argument; bypasses the default "sleep 60"

ENDOFUSAGE
    exit 1
}

# Main routine
# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]; then
    usage
    exit 2
fi

while [ $# -gt 0 ]; do
    case "$1" in
        -r) shift
            if [ $# -le 0 ]; then
                usage
            fi
            RNAME=$1
            SYS=$1
            ;;
        -now) NOW_FLAG=1 ;;
    esac
    shift
done

ps -e | grep claim96 > ${CHK_RPT}
if [ -s ${CHK_RPT} ]; then
    echo $ERR_MSG | /bin/mail -s "$SUBJECT" $MAILUSER
    exit 1
fi

if [ $NOW_FLAG -eq 0 ]; then
    sleep 60
fi

transfer_files() {
    local prefix=$1
    local numbers=("${!2}")
    local count=$3

    for ((i=0; i<count; i++)); do
        local filename="${prefix}-${numbers[i]}-${DATE}"
        scp -q ${RNAME}:${REMOTE_DIR}/${filename} ${HOST_DIR}/${filename}.tmp
        if [ $? -eq 0 ]; then
            mv ${HOST_DIR}/${filename}.tmp ${HOST_DIR}/${filename}.${SYS}
        fi
    done
}

# Transfer audit files
transfer_files "AUDIT" QNUMBERS[@] $QCOUNT

# Transfer individual DMR file
scp -q ${RNAME}:${REMOTE_DIR}/DMR-${DATE} ${HOST_DIR}/DMR-${DATE}.tmp
if [ $? -eq 0 ]; then
    mv ${HOST_DIR}/DMR-${DATE}.tmp ${HOST_DIR}/DMR-${DATE}.${SYS}
fi

# Transfer individual CLAIM02 file
scp -q ${RNAME}:${REMOTE_DIR}/CLAIM02 ${HOST_DIR}/CLAIM02.tmp
if [ $? -eq 0 ]; then
    mv ${HOST_DIR}/CLAIM02.tmp ${HOST_DIR}/CLAIM02-${DATE}.${SYS}
fi

# Transfer message files
transfer_files "MSG" QNUMBERS[@] $QCOUNT

# Transfer CLMSS files
transfer_files "CLMSS" QNUMBERS[@] $QCOUNT

# Transfer EFSS files
transfer_files "EFSS" QNUMBERS[@] $QCOUNT

# Transfer SCSS files
transfer_files "SCSS" QNUMBERS[@] $QCOUNT

${SHELL_DIR}/claim96.sh -d ${DATE}.${SYS} > ${RPT_DIR}/claim96 2>&1

exit 0

