#!/bin/sh

server="unknown"

mount_count=`df | grep -c "/media/backup"`

if [ "$mount_count" -gt "0" ]
then
	echo "/media/backup already mounted!"
	exit 1
fi

server="172.16.110.32"
	


#/usr/bin/smbmount  //${server}/ClientFiles /media/clientfiles -o username="pdmboardman\ClientFiles",password="cf2009access",uid=11,gid=130,fmask=664,dmask=775

mount -t cifs  //${server}/backups /media/backup -o  username="doesntmatter",password="doestmatter",uid=11,gid=130,file_mode=0664,dir_mode=0775,domain=pdmboardman

exit $?
