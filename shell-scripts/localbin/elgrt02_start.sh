#!/bin/sh

check_for_root()
{
        c_uid=`id -u`
        if [ "$c_uid" -ne "0" ]
        then
                echo "You need to be root to run this program!"
                exit 100
        fi
}

check_for_root

BIN_DIR=/usr/local/bin
LOG_DIR=/usr/local/logs/rte
SHELL_DIR=/usr/lnk/shell

# Program to start the realtime elig processing
${BIN_DIR}/clrmsg 80
${BIN_DIR}/clrmsg 79
su - pdmisvc -c "${SHELL_DIR}/elgrt02.sh -l 80 2>&1 | ${BIN_DIR}/logpipe -d -p ${LOG_DIR}/elgrt02 &"


