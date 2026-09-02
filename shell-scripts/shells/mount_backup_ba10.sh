#!/bin/sh

# Version 2.0
#	New BA10 backup server

server="unknown"

mount_count=`df | grep -c "/media/backup"`

if [ "$mount_count" -gt "0" ]
then
	echo "/media/backup already mounted!"
	exit 1
fi

server="BA10"
	



mount -t cifs  //${server}/Backups /media/backup -o  username="doesntmatter",password="doestmatter",uid=11,gid=130,file_mode=0664,dir_mode=0775,domain=pdmboardman

exit $?
