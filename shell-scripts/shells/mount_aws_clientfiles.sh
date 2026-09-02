#!/bin/sh

server="unknown"

mount_count=`df | grep -c "/media/clientfiles"`

if [ "$mount_count" -gt "0" ]
then
        echo "/media/clientfiles already mounted!"
        exit 1
fi



mount -t cifs "//file30/ClientFiles" -o username=ClientFiles,password=cf2009access,domain=PDMBOARDMAN,uid=11,gid=130,file_mode=0664,dir_mode=0775,vers=1\.0 /media/clientfiles/

exit $?
