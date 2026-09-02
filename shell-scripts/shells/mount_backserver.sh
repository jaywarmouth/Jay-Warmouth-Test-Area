#!/bin/sh
# Version 1.1 - 7/16/2009 Changed password  (LSJ)

BACKSERVER="172.16.102.43/backup"
MOUNTPOINT=/media/backup
host=`/bin/hostname -s`
QUIET="0"
OIFS="$IFS"
CR="
"

if [ "$1" = "-q" ] 
then
	QUIET="1"
fi

if [ ! -d "$MOUNTPOINT" ]
then
	echo "No such mountpoint $MOUNTPOINT"
	exit 1
fi

IFS="$CR"
for mpoint in `cat /etc/mtab|awk '{ print $2 }'`
do
	IFS="$OIFS"
	if [ "$mpoint" = "$MOUNTPOINT" ]
	then
		if [ "$QUIET" -eq "0" ]
		then
			echo "$MOUNTPOINT appears to already be mounted."
		fi
		exit 1
	fi
	IFS="$CR"
done

#/usr/bin/smbmount  //$BACKSERVER/$host $MOUNTPOINT -o username="backadm",password="pdm5409",uid=11,gid=130,fmask=664,dmask=775

#/usr/local/samba/sbin/mount.cifs  //$BACKSERVER/$host $MOUNTPOINT -o username="pdmboardman\BackupAdmin",password="pdm5409",uid=11,gid=130,fmask=644,dmask=775


#/usr/bin/smbmount  //$BACKSERVER/$host $MOUNTPOINT -o username="pdmboardman\BackupAdmin",password="pdm5409",uid=11,gid=130,fmask=644,dmask=775,lfs

#/usr/bin/smbmount  //$BACKSERVER/$host $MOUNTPOINT -o username="pdmboardman\ClientFiles",password="cf2009access",uid=11,gid=130,fmask=664,dmask=775

#mount -t cifs  //${BACKSERVER} $MOUNTPOINT -o  username="pdmboardman\BackupAdmin",password="pdm5409",uid=11,gid=130,file_mode=0664,dir_mode=0775,domain=pdmboardman

mount -t cifs  //${BACKSERVER} $MOUNTPOINT -o  username="pdmboardman\operator",password="oper7340",uid=11,gid=130,file_mode=0664,dir_mode=0775,domain=pdmboardman
