#!/bin/ksh
#
# Program Name	: sscclaim.sh
# Description	: Run daemon to recieve claims via TCP for SSC
#		  Uses queues 62 & 97.  Port 27000
# Author	: Steven Randlett
# Date		: 2-26-03
# Modifications :
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

USAGE: ${SCRIPT_NAME}.sh start|stop|clean_queues|status|pause_toggle
Program status can be found in /tmp/.tcpclaim.log

ENDOFUSAGE
  exit 1
}

showprocess()
{
if [ "$PROCESS_INFO" != "" ]
then

	echo "----------------------------------------------"
	echo $PROCESS_INFO
	echo "----------------------------------------------"

fi

}

#
# Main routine
#
SCRIPT_NAME="sscclaim"
PORT="27000"
RUN_AS="c04"

pid="pid"

ERR_FILE="/tmp/.${SCRIPT_NAME}.out.${PORT}"

# set -x

mkdir -p /tmp/lines/ssc > /dev/null 2>&1
chown c04 /tmp/lines/ssc
chmod 750 /tmp/lines/ssc

PROCESS_INFO=`ps -ef | grep sscclaim | egrep -v "sscclaim.sh|grep"`
pid=`echo ${PROCESS_INFO} | awk '{ print $2 }'`
if [ "$pid" = "" ] 
then
	pid="pid"
fi

if [ "$#" -lt 1 ]
then
	usage
fi

ACTION="$1"

case "$ACTION" in
'start')

	RUNLINE="nohup /usr/pdm/bin/sscclaim"
	su - ${RUN_AS} -c "${RUNLINE} 2>${ERR_FILE} >/tmp/lines/ssc/ssc.$$ &" 

	sleep 3

	if [ -s "$ERR_FILE" ]
	then
		cat $ERR_FILE
	fi
;;

'stop')

	showprocess
	echo "Send a kill -TERM pid to the parent process to shutdown"

;;
'pause_toggle')

	showprocess
	echo "Send a kill -USR2 pid to the parent process to toggle pause mode"
;;
'clean_queues')

	showprocess
	echo "Send a kill -USR1 pid to the parent process to clean queues"
;;
'status')
        /usr/bin/netstat -na | grep $PORT
;;



*) 
	usage
;;

esac

exit 0
