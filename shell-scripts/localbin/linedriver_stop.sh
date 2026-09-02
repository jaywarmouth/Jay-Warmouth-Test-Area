#!/bin/sh


#       Name: linedriver_stop.sh
#       By  : Steven Randlett
#       Date: 03/03/99
#       Purpose: Kill off all envoy/ndc lines
#
#	Updated 7/23/2020 SRR
#

OIFS="$IFS"
CR="
"


usage()
{
echo "USAGE: $0 line"
echo "where line is sw10,sw16,sw40,sw60,sw70,sw90,general"
}


hard_kill()
{
LINENAME="$1"

	IFS="$CR"

	for line in `ps -ef | grep tcplinedrv | grep -a -i "$LINENAME"`
	do
		IFS="$OIFS"
		process_id=`echo "$line" | awk '{ print $2 }'`
		kill -9 $process_id
		IFS="$CR"
	done

	IFS="$OIFS"
	

}

do_kill()
{
OPT="$1"
LINEFILE="$2"
LINENAME="$3"

#set -x
if [ -r "$LINEFILE" ]
then
	pid=`cat $LINEFILE | head -1 | awk '{ print $2 }'`
	junk=`ps -fp $pid | grep "tcplinedrv"`
	if [ "$junk" = "" ]
	then
		echo "No daemon appears to be running for $LINENAME."
	else
		kill $OPT $pid
	fi
else
	echo "No daemon appears to be running for $LINENAME (no lineinfo file)."
fi

	hard_kill "$LINENAME"

}


#
# MAIN
#

LINETYPE="$1"
KILL_OPTS="$2"

SWITCH10_FILE="/usr/local/logs/linedrv/switch10/lineinfo"
SWITCH16_FILE="/usr/local/logs/linedrv/switch16/lineinfo"
SWITCH40_FILE="/usr/local/logs/linedrv/switch40/lineinfo"



if [ "$KILL_OPTS" = "" ]
then
	KILL_OPTS="-HUP"
elif [ "$KILL_OPTS" = "term" ]
then
	KILL_OPTS="-TERM"
else
	usage
	exit 1
fi

if [ "$LINETYPE" = "" ]
then
	usage
	exit 1

elif [ "$LINETYPE" = "sw10" ]
then
	do_kill "$KILL_OPTS" "${SWITCH10_FILE}" "Switch10"

elif [ "$LINETYPE" = "sw16" ]
then
	do_kill "$KILL_OPTS" "${SWITCH16_FILE}" "Switch16"

elif [ "$LINETYPE" = "sw40" ]
then
	do_kill "$KILL_OPTS" "${SWITCH40_FILE}" "Switch40"

elif [ "$LINETYPE" = "all" ]
then
	do_kill "$KILL_OPTS" "${SWITCH16_FILE}" "Switch10"
	do_kill "$KILL_OPTS" "${SWITCH16_FILE}" "Switch16"
	do_kill "$KILL_OPTS" "${SWITCH40_FILE}" "Switch40"

else
	usage
	exit 1
fi


