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


/usr/lnk/shell/scan_and_send_rtc.sh /tmp/rtc  | /usr/local/bin/logpipe -d -p /tmp/.scan_and_send_rtc 2>&1 &

