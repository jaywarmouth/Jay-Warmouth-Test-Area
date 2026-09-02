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
datetime=`/bin/date "+%Y%m%d_%H%M%S"`

# Program to start the realtime outbound claims transmissions
su - c04 -c "nohup /usr/lnk/shell/clmrt01.sh -l 6867 -v 2>&1 | /usr/local/bin/logpipe -d -p /tmp/.clmrt01 &"


