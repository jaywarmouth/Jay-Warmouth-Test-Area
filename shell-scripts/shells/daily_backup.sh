#!/bin/sh


#
# Daily backup
# Linda Jefferis
# 6/29/06
#
# Version 1.7


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
MEDIADIR="/media/Backup_Volume"
OUTDIR="${MEDIADIR}/${SERVER}/daily"
CLEANUP_CMD="/usr/lnk/shell/clean_dir.sh"


# file system list to backup   directory:output_file_name
case ${SERVER} in
  "rook")
	FS_LIST="/etc/shadow:shadow /etc/group:group /etc/passwd:passwd /home:home /usr/data:data /usr/clm/clm_01:clm_01 /usr/flexgen:flexgen"
	;;
  "robin")
	FS_LIST="/etc/shadow:shadow /etc/group:group /etc/passwd:passwd /home:home /usr/pdm:pdm /usr/flexgen:flexgen /usr/tmp_wrk:tmp_wrk"
	;;
  "husk")
	FS_LIST="/etc/shadow:shadow /etc/group:group /etc/passwd:passwd /home:home /usr/pdm:pdm"
	;;
  "firefly")
	FS_LIST="/etc/shadow:shadow /etc/group:group /etc/passwd:passwd /home:home /usr/pdm/elig_in:elig_in /usr/pdm/elig_out:elig_out"
	;;
esac


MOUNTED=`$DFCMD | grep ${MEDIADIR}`

if [ "${MOUNTED}" = "" ]
then
	/bin/mount $MEDIADIR
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

date
