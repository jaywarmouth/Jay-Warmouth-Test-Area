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

# Program to start the realtime card order program
/usr/local/bin/clrmsg 78
#${SHELL_DIR}/crdrt01.sh -l 78 >> ${LOG_DIR}/.crdrt01.${datetime}.log 2>&1 &
su - pdmisvc -c "${SHELL_DIR}/crdrt01.sh -l 78 | ${BIN_DIR}/logpipe -d -p ${LOG_DIR}/.crdrt01 2>&1 &"

