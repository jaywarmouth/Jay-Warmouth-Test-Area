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
LOG_DIR=/usr/local/logs/formulary
SHELL_DIR=/usr/lnk/shell

# Program to start the realtime processing
/usr/local/bin/clrmsg 125
/usr/local/bin/clrmsg 126
/usr/local/bin/clrmsg 127
/usr/local/bin/clrmsg 128
/usr/local/bin/clrmsg 129
su - pdmisvc -c "${SHELL_DIR}/formulary73.sh -l 125 2>&1 | ${BIN_DIR}/logpipe -d -p ${LOG_DIR}/formulary73 &"
