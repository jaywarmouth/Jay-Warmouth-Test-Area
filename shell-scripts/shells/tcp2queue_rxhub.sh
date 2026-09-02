#!/bin/ksh
#
# Program Name	: tcp2queue.sh
# Description	: Run daemon to recieve claims via TCP
# Author	: Steven Randlett
# Date		: 3/27/08
# Modifications : 8/19/2013 - Added logpipe logic for command (LSJ)
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
SCRIPT_NAME="tcp2queue_rxhub"
CONFIG_FILE="/usr/local/pub/tcp2queue_rxhub.cfg"
PORT="10800"
RUN_AS="root"

ERR_FILE="/tmp/.${SCRIPT_NAME}.out"

# set -x

if [ "$#" -lt 1 ]
then
	usage
fi

ACTION="$1"

case "$ACTION" in
'start')

	RUNLINE="nohup /usr/local/bin/tcp2queue -f $CONFIG_FILE"
	#su - ${RUN_AS} -c "${RUNLINE} >${ERR_FILE} 2>&1 &"
	su - ${RUN_AS} -c "${RUNLINE} | /usr/local/bin/logpipe -d -p ${ERR_FILE} 2>&1 &"

	sleep 3

	if [ -s "$ERR_FILE" ]
	then
		cat $ERR_FILE
	fi
;;

'stop')
#        /usr/lnk/shell/tcpclaim_signal.sh stop $PORT

;;
'status')
        /bin/netstat -na | grep $PORT
;;


*) 
	usage
;;

esac

exit 0
