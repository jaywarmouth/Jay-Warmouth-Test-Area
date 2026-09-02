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
LHOST=`/bin/hostname -s`

BIN_DIR=/usr/local/bin
LOG_DIR=/usr/local/logs/epres
SHELL_DIR=/usr/lnk/shell

${SHELL_DIR}/range_clrmsg.sh 800 805

# Program to start ePrescribing COBOL program
su - pdmisvc -c "${SHELL_DIR}/etraf01.sh -l 800 2>&1 | ${BIN_DIR}/logpipe -d -p ${LOG_DIR}/etraf01"

