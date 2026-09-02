#!/bin/sh

server="unknown"

mount_count=`df | grep -c "/media/clientfiles"`

if [ "$mount_count" -gt "0" ]
then
        echo "/media/clientfiles already mounted!"
        exit 1
fi

#site=`/usr/lnk/shell/whatsite.sh`
#
#if [ "$site" = "0" ]
#then
#       echo "mount_clientfiles.sh: whatsite.sh: Unable to determine site."
#       exit 1
#fi

#server="file${site}0"



mount -t cifs "//file30/ClientFiles" -o username=ClientFiles,password=cf2009access,domain=PDMBOARDMAN,uid=11,gid=130,file_mode=0664,dir_mode=0775,vers=1\.0 /media/clientfiles/

#mount -t cifs  //${server}/ClientFiles /media/clientfiles -o username="ClientFiles",password="cf2009access",uid=11,gid=130,file_mode=0664,dir_mode=0775,domain=pdmboardman

exit $?
