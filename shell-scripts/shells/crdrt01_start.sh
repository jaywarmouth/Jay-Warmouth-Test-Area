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

# Program to start the realtime card order program
/usr/local/bin/clrmsg 78
su - c04 -c "/usr/lnk/shell/crdrt01.sh -l 78 >> /tmp/.crdrt01.${datetime}.log 2>&1 &"

