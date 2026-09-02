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
/usr/local/bin/clrmsg 83
/usr/local/bin/clrmsg 82
su - c04tst -c "/usr/tst/shell/elgrt_tst.sh -t -l 83 | /usr/local/bin/logpipe -d -p /tmp/.elgrt_tst 2>&1 &"


