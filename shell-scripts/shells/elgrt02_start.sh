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
/usr/local/bin/clrmsg 80
/usr/local/bin/clrmsg 79
su - c04 -c "/usr/lnk/shell/elgrt02.sh -l 80 2>&1 | /usr/local/bin/logpipe -d -p /tmp/.elgrt02 &"


