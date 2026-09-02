#!/bin/sh
#set -x
LOCKFILE="/tmp/.archive_realtime_datafiles.lock"
if [ -f "$LOCKFILE" ]
then
	echo "Program already running"
	exit 1
fi
touch $LOCKFILE
trap 'rm -f $LOCKFILE' 0

OIFS="$IFS"
CR="
"

DATAFILE="/usr/local/pub/tcpfileclaim.clients"


IFS="$CR"
for line in `cat $DATAFILE | grep -v "^#"`
do
	IFS="$OIFS"
	CLIENTID=`echo $line | awk '{ print $1 }'`
	FILEPATH=`echo $line | awk '{ print $2 }'`

	nice -15 /usr/lnk/shell/archive_realtime_datafiles.sh $FILEPATH $CLIENTID

	IFS="$CR"
done
	nice -15 /usr/lnk/shell/archive_realtime_datafiles.sh /usr/lnk/e-pres ep
