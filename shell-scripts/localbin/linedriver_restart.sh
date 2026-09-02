#!/bin/sh


#       Name: linedriver_restart.sh
#       By  : Steven Randlett
#       Date: 2020-07-23
#       Purpose: restart linedrivers
#
#


usage()
{
echo "USAGE: $0 line"
echo "where line is sw16, sw40, or all"
}

#
# MAIN
#

LINETYPE="$1"


PDM_PATH=/usr/local/bin
PDM_SHELL=/usr/lnk/shell
PDM_LOG=/usr/local/logs
PDM_CONFIG=/usr/local/etc
LHOST=`/bin/hostname -s`

STOP_SHELL="/usr/local/bin/linedriver_stop.sh"
START_SHELL="/usr/local/bin/linedriver_start.sh"

MAX_RETRY_SECONDS=120


do_restart()
{
linetype="$1"

case $linetype in
"sw16") 
	portnumber="10200"
	;;
"sw40")
	portnumber="10300"
	;;
*)
	echo "Unknown linetype $linetype"
	exit 1
	;;
esac


counter=0
connection_count=1

FAIL_RESTART=0

$STOP_SHELL $linetype

until [ "$connection_count" -eq "0" ]; do
	connection_count=`netstat -na | grep $portnumber | wc -l`
	counter=`expr $counter + 1`


#	echo "connection count: $connection_count"
#	echo "counter: $counter"

	if [ `expr "$counter" % 5` -eq "0" ]
	then
		echo "Waiting on connections to close for $linetype. $connection_count remaining."
	fi

	if [ "$counter" -gt "$MAX_RETRY_SECONDS" ]
	then
		FAIL_RESTART="1"
		break
	fi

	sleep 1
done

	if [ "$FAIL_RESTART" -eq "1" ]
	then
		echo "Connections still open."
		echo "Unable to restart linedriver $linetype"
	else
		$START_SHELL $linetype
		if [ "$?" -eq "0" ]
		then
			echo "$linetype started."
		else
			echo "$linetype failed to start."
		fi
	fi

}


if [ "$LINETYPE" = "" ]
then
	usage
	exit 1

elif [ "$LINETYPE" = "sw16" ]
then

echo "Restarting Switch16 linedriver daemon"
do_restart $LINETYPE


elif [ "$LINETYPE" = "sw40" ]
then
echo "Restarting Switch40 linedriver daemon"
do_restart $LINETYPE


elif [ "$LINETYPE" = "all" ]
then
echo "Restarting Switch16 linedriver daemon"
do_restart "sw16" &

echo "Restarting Switch40 linedriver daemon"
do_restart "sw40" &

wait



else
	usage
	exit 1
fi


