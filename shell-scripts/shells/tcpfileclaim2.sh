#!/bin/ksh
#
# Program Name	: tcpfileclaim.sh
# Description	: Run daemon to recieve claims via TCP
# Author	: Steven Randlett
# Date		: 1/7/05
# Modifications :
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ${SCRIPT_NAME}.sh start|stop|pause_toggle

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
SCRIPT_NAME="tcpfileclaim2"
CONFIG_FILE="/usr/local/pub/realtime_tcpfileclaim2.cfg"
PORT="10084"
RUN_AS="c04"

#ERR_FILE="/tmp/.${SCRIPT_NAME}.out"
ERR_FILE="/tmp/.${SCRIPT_NAME}"

# set -x

if [ "$#" -lt 1 ]
then
	usage
fi

ACTION="$1"

case "$ACTION" in
'start')

	RUNLINE="nohup /usr/local/bin/tcpfileclaim -f $CONFIG_FILE"
#	su - ${RUN_AS} -c "${RUNLINE} >${ERR_FILE} 2>&1 &"
	su - ${RUN_AS} -c "${RUNLINE} | /usr/local/bin/logpipe -d -p ${ERR_FILE} 2>&1 &"

#	su - ${RUN_AS} -c "${RUNLINE} 2>${ERR_FILE} >/dev/null &" 

	sleep 3

	if [ -s "$ERR_FILE" ]
	then
		cat $ERR_FILE
	fi
;;

'stop')
        /usr/lnk/shell/tcpclaim_signal.sh stop $PORT

;;
'pause_toggle')
        /usr/lnk/shell/tcpclaim_signal.sh pause_toggle $PORT
;;
'clean_queues')
        /usr/lnk/shell/tcpclaim_signal.sh clean $PORT
;;
'status')
        /bin/netstat -na | grep $PORT
;;


*) 
	usage
;;

esac

exit 0
