#!/bin/sh


#
# Pdm ARchiver
# Steven Randlett
# 6/1/06
# cpio/gzip/pgp files.  Also will restore files.

# Important note on USB disks using vfat file system:
# The vfat file system does not support file ownership (chown) or
# file permissions (chmod).  Whoever mounts the drive (usually root) will
# have ownership of the drive and will be the only user able to write to
# the mounted USB device.  Furthermore, if you restore to the USB device
# (say from a cpio file) the ownership and permissions on the file
# will not take effect on the CPIO restore because chmod/chown do not
# work on the vfat file system.



usage() {

echo "USAGE: par.sh [-e] [-l] -r|-b -s src -d dst [-f \"file\"]  "
echo "	-e           - disables PGP encryption"
echo "	-l           - do not create file listing"
echo "	-b           - perform backup"
echo "	-r           - perform restore"
echo "	-s src       - Source directory/file to backup/restore"
echo "	-d dst       - path & filename of output file"
echo "	-f file      - path & filename to restore"
echo "Version $VERSION"
echo " "

exit 1

}

#
# MAIN
#

VERSION="1.3"

CPIOCMD="/bin/cpio"
GPGCMD="/usr/bin/gpg"
GZIPCMD="/bin/gzip"
GUNZIPCMD="/bin/gunzip"
FINDCMD="/usr/bin/find"

# Encrypt yes/no
PGP="1"

# create listing file
CREATELIST="1"

# Gethost
SERVER=`/bin/hostname -s`

# CPIO options
CPIO_OPTS="-ovc"
CPIO_EXTRACT_OPTS="-ivdm --no-absolute-filenames"

# find options
FIND_OPTS="-mount -xdev -print -depth"

DOBACKUP="0"
DORESTORE="0"

RESTOREFILES=""

while [ "$1" != "" ]
do

	case "$1" in
		'-b')
			DOBACKUP="1"
			;;
		'-l')
			CREATELIST="0"
			;;
		'-r')
			DORESTORE="1"
			;;
		'-e')
			PGP="0"
			;;
		'-s')
			SOURCE_DIR="$2"
			shift
			;;
		'-d')
			DEST="$2"
			shift
			;;
		'-f')
			RESTOREFILES="$2"
			shift
			;;
		*)
			usage

	esac

	shift
done

if [ "$DEST" = "" ]
then
	usage
	exit 1
fi

# Fail if you try to do both or neither.
if [ "$DOBACKUP" -eq "$DORESTORE" ]
then
	usage
	exit 1
fi

CPIO_FILENAME="${DEST}.cpio.gz"
	
PGP_FILENAME="${CPIO_FILENAME}.pgp"


if [ "$PGP" -eq "1" ]
then
	LISTFILE="${PGP_FILENAME}.lst"
else
	LISTFILE="${CPIO_FILENAME}.lst"
fi
 

if [ "$DOBACKUP" -eq "1" ]
then
# DO BACKUP

	if [ "$CREATELIST" -eq "1" ]
	then
		echo "Backup started `/bin/date` on $SERVER"  >$LISTFILE
	else
		echo "Backup started `/bin/date` on $SERVER"  
	fi

	if [ "$PGP" -eq "1" ]
	then
		if [ "$CREATELIST" -eq "1" ] 
		then
			$FINDCMD "$SOURCE_DIR" $FIND_OPTS | $CPIOCMD $CPIO_OPTS 2>> ${LISTFILE} | $GZIPCMD | $GPGCMD -e -r "PDM Backups" > $PGP_FILENAME 
		else
			$FINDCMD "$SOURCE_DIR" $FIND_OPTS | $CPIOCMD $CPIO_OPTS  | $GZIPCMD | $GPGCMD -e -r "PDM Backups" > $PGP_FILENAME 

		fi



	else
	# NO PGP
		if [ "$CREATELIST" -eq "1" ] 
		then
			$FINDCMD "$SOURCE_DIR" $FIND_OPTS | $CPIOCMD $CPIO_OPTS 2>> ${LISTFILE} | $GZIPCMD > $CPIO_FILENAME
		else
			$FINDCMD "$SOURCE_DIR" $FIND_OPTS | $CPIOCMD $CPIO_OPTS  | $GZIPCMD > $CPIO_FILENAME

		fi


	fi

	if [ "$CREATELIST" -eq "1" ]
	then
		echo "Backup completed `/bin/date`" >>$LISTFILE
		$GZIPCMD "$LISTFILE"
	else
		echo "Backup completed `/bin/date`" 
	fi
else 
# DO RESTORE
	echo "Restore started `/bin/date` on $SERVER"

	if [ ! -d "$DEST" ] 
	then
		echo "Destination $DEST must be a directory."
		exit 3
	fi

	cd $DEST

	if [ ! -r "$SOURCE_DIR" ] 
	then
		echo "Source file $SOURCE_DIR does not exist or is not readable"
		echo "Be sure to use the full path for the source file!"
		exit 3
	fi

	if [ "$PGP" -eq "1" ]
	then
		cat "$SOURCE_DIR" | $GPGCMD -d | $GUNZIPCMD | $CPIOCMD $CPIO_EXTRACT_OPTS $RESTOREFILES

	else
		cat "$SOURCE_DIR" | $GUNZIPCMD | $CPIOCMD $CPIO_EXTRACT_OPTS  


	fi

	echo "Restore completed `/bin/date`"




fi
