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

# Program to start the realtime elig processing
/usr/local/bin/clrmsg 84
/usr/local/bin/clrmsg 61
/usr/lnk/shell/elgrt01.sh -l 84 >> /tmp/.elgrt01.log 2>&1 &


