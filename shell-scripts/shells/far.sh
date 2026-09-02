#!/bin/sh


trap 'rm -f $TMPFILE' 0


YM=`date '+%Y%m'`
TSTAMP=`date '+%D %T'`

TMPFILE="/tmp/far.tmp.$$"
LOGFILE="/var/log/far/far.$YM.csv"

touch $LOGFILE

if [ ! -s $LOGFILE ]
then
	echo "\"Time\",\"FG4 Internal\", \"FG4 External\", \"RUNCOBOL\"" >>$LOGFILE
fi

ps -ef>$TMPFILE
FG4I=`cat $TMPFILE|grep "runfg4" | grep -v "USER=" | grep -v "grep" | wc -l`
FG4E=`cat $TMPFILE|grep "runfg4" | grep "USER=" | grep -v "grep" | wc -l`
RC=`cat $TMPFILE|grep "runcobol"  | grep -v "grep" | wc -l`


#echo $LOGFILE


echo "\"$TSTAMP\", $FG4I, $FG4E,$RC" >>$LOGFILE


