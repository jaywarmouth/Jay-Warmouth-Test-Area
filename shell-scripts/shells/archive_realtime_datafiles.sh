#!/bin/sh
#set -x
usage() {
$0 path ClientID
exit 1
}

#FILEDATE=`date +%Y%m`
#FILEDATEDAY=`date +%Y%m%d`
#ARCHIVEFILE="datafile_archive.${FILEDATE}.zip"
#OUTFILE="/tmp/.archive_realtime_datafiles.out.$FILEDATEDAY"



FILEPATH="$1"
CLIENTID="$2"

if [ "$CLIENTID" = "" ]
then
	usage
	exit 1
fi

if [ ! -d "$FILEPATH" ]
then
	echo "$FILEPATH is not a directory!"
	exit 1
fi

TARGETFILE="${CLIENTID}_[DR]_????????????_*"

cd $FILEPATH

find . -ctime +1 -name "$TARGETFILE" -exec rm -f {} \;
