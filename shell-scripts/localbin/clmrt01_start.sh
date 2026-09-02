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
LOG_DIR=/usr/local/logs/rtc
SHELL_DIR=/usr/lnk/shell

cd ${LOG_DIR}

# Program to start the realtime outbound claims transmissions
su - pdmisvc -c "${SHELL_DIR}/clmrt01.sh -l 6867 -v 2>&1 | ${BIN_DIR}/logpipe -d -p ${LOG_DIR}/clmrt01"


