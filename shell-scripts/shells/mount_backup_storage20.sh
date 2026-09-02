#!/bin/sh

# Version 1.0
#	New storage20 backup server

server="unknown"

mount_count=`df | grep -c "/media/backup"`

if [ "$mount_count" -gt "0" ]
then
	echo "/media/backup already mounted!"
	exit 1
fi

server="storage20"
	



mount -t cifs  //${server}/Archives/Operations /media/backup -o  username="fileshares",password="Pdmi62534",uid=11,gid=130,file_mode=0664,dir_mode=0775,domain=pdmboardman

exit $?
