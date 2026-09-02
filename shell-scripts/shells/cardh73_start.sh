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

# Program to start the hospice realtime processing
/usr/local/bin/clrmsg 86
/usr/local/bin/clrmsg 85
/usr/lnk/shell/cardh73.sh -l 86 >> /tmp/.cardh73.log 2>&1 &


