#!/bin/sh


#
# Root backup
# Steven Randlett
# 6/2/06
#
# Version 1.6


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
OUTDIR="${MEDIADIR}/${SERVER}/root"


# file system list to backup directory:output_file_name
FS_LIST="/:root /usr:usr /home:home /usr/clm:clm /usr/data:data /usr/pdm:pdm /var:var"

MOUNTED=`$DFCMD | grep ${MEDIADIR}`

if [ "${MOUNTED}" = "" ]
then
	/usr/lnk/shell/mount_backup_ba20.sh
fi

MOUNTED=`$DFCMD | grep ${MEDIADIR}`

if [ "${MOUNTED}" = "" ]
then
	echo "It does not appear as though $MEDIADIR is mounted."
	exit 1
fi

if [ ! -d "$OUTDIR" ]
then
	mkdir -p $OUTDIR
fi

cp $PARCMD "${OUTDIR}"


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

	echo "Backing up $DIR"
	$PARCMD -b -s $DIR -d $OUTFILE
done
