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

# Program to start the realtime processing
/usr/local/bin/clrmsg 125
/usr/local/bin/clrmsg 126
/usr/local/bin/clrmsg 127
/usr/local/bin/clrmsg 128
/usr/local/bin/clrmsg 129
su - c04 -c "/usr/lnk/shell/formulary73.sh -l 125 2>&1| /usr/local/bin/logpipe -d -p /tmp/.formulary73 &"
