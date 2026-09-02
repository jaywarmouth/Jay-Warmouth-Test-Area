#!/bin/sh


#
# Daily backup
# Linda Jefferis
# 5/13/2011
#
# Version 1.0
#Modifications  : 09/05/2013 - Rename daily_backup_strg20.sh (DME)
#		: 09/05/2013 - change mount_backup_ba20.sh to mount_backup_storage20.sh(DME)
#		: 09/09/2013 - updated FS_list for robin and removed logic for husk and devtest20(DME)
#		: 03/27/2014 - Added medd directory to backup list
#		: 05/23/2017 - TT13915-51; changed mount script name for new storage21.
#		: 02/02/2018 - Remove /nfs reference for robin backup
#		: 04/2019 - TT13915-83 changes
#		: 10/29/2019 - Changes for new Robin flexgen environments
#		

date

wday="`/bin/date "+%a"`"

# Only run on a sunday flag.  Send in -s if you want to do this 
if [ "$1" = "-s" ]
then
	if [ "$wday" != "Sun" ]
	then
		exit 0
	fi
			
fi


DFCMD="/bin/df"
PARCMD="/usr/lnk/shell/par.sh"
SERVER="`/bin/hostname -s`"
MEDIADIR="/media/backup"
OUTDIR="${MEDIADIR}/${SERVER}/daily"
CLEANUP_CMD="/usr/lnk/shell/clean_dir.sh"
CR=""



# Try mounting the backup server, quietly
/usr/lnk/shell/mount_backup_storage21.sh -q

MOUNTED=`$DFCMD | grep ${MEDIADIR}`

if [ "${MOUNTED}" = "" ]
then
        echo "It does not appear as though $MEDIADIR is mounted."
        exit 99
fi

if [ ! -d "$OUTDIR" ]
then
	mkdir -p $OUTDIR
fi

echo "Running clean_dir.sh for $OUTDIR"
date
$CLEANUP_CMD $OUTDIR 14

# file system list to backup   directory:output_file_name
FS_LIST="/home:home /opt/flexgen:flexgen /usr/pdm/programs/tst:tst /usr/pdm/test:test"

for line in $FS_LIST
do
	DIR=`echo $line | awk -F: '{ print $1 }'`
	FNAME=`echo $line | awk -F: '{ print $2 }'`

	OUTDATE=`/bin/date "+%Y%m%d"`
	OUTFILE="${OUTDIR}/${FNAME}.${SERVER}.${OUTDATE}"

	echo "Backing up $DIR"
	date
	$PARCMD -b -s $DIR -d $OUTFILE
done

# Make backup copy of current par.sh script
cp $PARCMD $OUTDIR

# Try unmounting $MEDIADIR
echo "Unmounting $MEDIADIR"
/bin/umount $MEDIADIR

date
