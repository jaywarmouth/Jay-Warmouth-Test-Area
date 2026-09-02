#!/bin/sh


#
# Daily backup
# Linda Jefferis
# 5/13/2011
#
# Version 1.0


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
CR="
"


# file system list to backup   directory:output_file_name
case ${SERVER} in
  "robin")
	FS_LIST="/etc/shadow:shadow /etc/group:group /etc/passwd:passwd /home:home /usr/pdm:pdm /usr/flexgen703:flexgen /usr/tmp_wrk:tmp_wrk"
	;;
  "husk")
	FS_LIST="/etc/shadow:shadow /etc/group:group /etc/passwd:passwd /home:home /usr/pdm:pdm"
	;;
  "DevTest20")
	FS_LIST="/:root /usr:usr /home:home /var"
	;;
esac




# Try mounting the backup server, quietly
/usr/lnk/shell/mount_backup_ba20.sh -q


OIFS="$IFS"
IFS="$CR"
FOUND="0"
for mpoint in `cat /etc/mtab|awk '{ print $2 }'`
do
        IFS="$OIFS"
        if [ "$mpoint" = "$MEDIADIR" ]
        then
                FOUND="1"
        fi
        IFS="$CR"
done

IFS="$OIFS"

if [ "$FOUND" -ne "1" ]
then
        echo "$MEDIADIR is not mounted!"
        exit 1
fi


if [ ! -d "$OUTDIR" ]
then
	mkdir -p $OUTDIR
fi

for line in $FS_LIST
do
	DIR=`echo $line | awk -F: '{ print $1 }'`
	FNAME=`echo $line | awk -F: '{ print $2 }'`
	OUTDIR_TMP="${OUTDIR}/${FNAME}"
        if [ ! -d "$OUTDIR_TMP" ]
        then
                mkdir -p $OUTDIR_TMP
        fi

	OUTDATE=`/bin/date "+%Y%m%d"`
	OUTFILE="${OUTDIR_TMP}/${FNAME}.${SERVER}.${OUTDATE}"

	echo "Running clean_dir.sh for $OUTDIR_TMP"
	date
	$CLEANUP_CMD $OUTDIR_TMP 14

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
