#!/bin/ksh
#
# Program Name	: tcpclaim_stop.sh
# Description	: Shutdown an active tcpclaim/sscclaim daemon
# Author	: Steven Randlett
# Date		: 2-26-03
# Modifications :
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: tcpclaim_signal.sh stop|clean|pause_toggle port

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

MESSAGE="***PID_TCPCLAIM***"

if [ "$#" -lt 2 ]
then
	usage
fi

port="$2"
action="$1"

PID_FILE="/tmp/.tcpclaim_pid.${port}"

rm -f $PID_FILE

case $action in

'stop')

	echo $MESSAGE|telnet localhost $port >/dev/null 2>&1
	sleep 2

	if [ -f "$PID_FILE" ] 
	then
		kill -TERM `cat $PID_FILE`
		rm -f $PID_FILE
	else
		echo "No response from daemon.  Already stopped?"	
	fi
	;;
'clean')
	echo $MESSAGE|telnet localhost $port >/dev/null 2>&1
	sleep 2

	if [ -f "$PID_FILE" ] 
	then
		kill -USR1 `cat $PID_FILE`
		rm -f $PID_FILE
	else
		echo "No response from daemon."	
	fi
	;;
'pause_toggle')

	echo -n $MESSAGE | telnet localhost $port >/dev/null 2>&1
	sleep 2

	if [ -f "$PID_FILE" ] 
	then
		kill -USR2 `cat $PID_FILE`
		rm -f $PID_FILE
	else
		echo "No response from daemon."	
	fi
	;;

*)
	usage

esac

exit 0
