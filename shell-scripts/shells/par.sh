#!/bin/sh


#
# Pdm ARchiver
# Steven Randlett
# 8/22/06
# tar/gzip/pgp files.  Also will restore files.

# Important note on USB disks using vfat file system:
# The vfat file system does not support file ownership (chown) or
# file permissions (chmod).  Whoever mounts the drive (usually root) will
# have ownership of the drive and will be the only user able to write to
# the mounted USB device.  Furthermore, if you restore to the USB device
# (say from a cpio file) the ownership and permissions on the file
# will not take effect on the CPIO restore because chmod/chown do not
# work on the vfat file system.

# Modified to use tar instead of cpio due to 2GB limitation on CPIO.



usage() {

echo "$0 Version $VERSION"
echo "USAGE: par.sh [-e] [-l] -r|-b -s src -d dst [-f \"file\"]  "
echo "	-e           - disables PGP encryption"
echo "	-l           - do not create file listing"
echo "	-b           - perform backup"
echo "	-r           - perform restore"
echo "	-s src       - in backup this is the source directory/file to backup"
echo "		       in restore this is the filename of the backup file"
echo "	-d dst       - in backup this is the file to write the backups to"
echo "                 in restore this is the directory to restore files to"
echo "	-f file      - option file to restore, by default all files are restored"
echo " "
echo "Examples:"
echo "Backup files in /mydir to a file called mybackupfile:"
echo "	par.sh -b -s /mydir -d mybackupfile"
echo "To restore files in mybackupfile to /tmp directory:"
echo "	par.sh -r -s mybackupfile -d /tmp"
echo "To restore a single directory from a backup:"
echo "	par.sh -r -s mybackupfile -d /tmp -f \"full/path\""
echo "To restore a single file from a backup:"
echo "	par.sh -r -s mybackupfile -d /tmp -f \"full/path/filename\""
echo "Note: When restoring a dir/file the path should *not* be prefixed with a slash"
echo " "

exit 1

}

#
# MAIN
#

VERSION="2.2"

TARCMD="/bin/tar"
GPGCMD="/usr/bin/gpg"
GZIPCMD="/bin/gzip -f"
GUNZIPCMD="/bin/gunzip"
# Encrypt yes/no
PGP="1"

# create listing file
CREATELIST="1"

# Gethost
SERVER=`/bin/hostname -s`

# TAR options
TAR_OPTS="-cvlz"
TAR_EXTRACT_OPTS="-xvz"

# find options
# FIND_OPTS="-mount -xdev -print -depth"

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

TAR_FILENAME="${DEST}.tgz"
	
PGP_FILENAME="${TAR_FILENAME}.pgp"


if [ "$PGP" -eq "1" ]
then
	LISTFILE="${PGP_FILENAME}.lst"
else
	LISTFILE="${TAR_FILENAME}.lst"
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
			$TARCMD $TAR_OPTS "$SOURCE_DIR" 2>> ${LISTFILE} | $GPGCMD -e -r "PDM Backups" > $PGP_FILENAME 
		else
			$TARCMD $TAR_OPTS "$SOURCE_DIR" 2>> /dev/null | $GPGCMD -e -r "PDM Backups" > $PGP_FILENAME 

		fi



	else
	# NO PGP
		if [ "$CREATELIST" -eq "1" ] 
		then
			$TARCMD $TAR_OPTS "$SOURCE_DIR" 2>> ${LISTFILE} > $TAR_FILENAME 
		else
			$TARCMD $TAR_OPTS "$SOURCE_DIR" 2>> /dev/null > $TAR_FILENAME 

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
		cat "$SOURCE_DIR" | $GPGCMD -d | $TARCMD $TAR_EXTRACT_OPTS $RESTOREFILES

	else
		cat "$SOURCE_DIR" | $TARCMD $TAR_EXTRACT_OPTS  


	fi

	echo "Restore completed `/bin/date`"




fi
