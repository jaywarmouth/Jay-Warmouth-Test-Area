#!/bin/sh

server="unknown"

mount_count=`df | grep -c "/media/clientfiles"`

if [ "$mount_count" -gt "0" ]
then
	echo "/media/clientfiles already mounted!"
	exit 1
fi

site=`/usr/lnk/shell/whatsite.sh`

if [ "$site" = "0" ]
then
	echo "mount_clientfiles.sh: whatsite.sh: Unable to determine site."
	exit 1
fi

server="file${site}0"

# added to force file30 as mount point
server="file30"
	


#/usr/bin/smbmount  //${server}/ClientFiles /media/clientfiles -o username="pdmboardman\ClientFiles",password="cf2009access",uid=11,gid=130,fmask=664,dmask=775

mount -t cifs  //${server}/ClientFiles /media/clientfiles -o username="ClientFiles",password="cf2009access",uid=11,gid=130,file_mode=0664,dir_mode=0775,domain=pdmboardman

exit $?
