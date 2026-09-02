#!/bin/sh
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
BIN_DIR=/usr/local/bin
LOG_DIR=/usr/local/logs/epres
SCRIPT_NAME="tcp2queue_rxhub"
CONFIG_FILE="/usr/local/etc/epres/tcp2queue_rxhub.cfg"
PORT="10800"
RUN_AS="pdmisvc"

ERR_FILE="${LOG_DIR}/${SCRIPT_NAME}"

# set -x

if [ "$#" -lt 1 ]
then
	usage
fi

ACTION="$1"

case "$ACTION" in
'start')

	RUNLINE="nohup ${BIN_DIR}/tcp2queue -f $CONFIG_FILE"
	su - ${RUN_AS} -c "${RUNLINE} | ${BIN_DIR}/logpipe -d -p ${ERR_FILE} 2>&1 &"

	sleep 3

	if [ -s "$ERR_FILE" ]
	then
		cat $ERR_FILE
	fi
;;

'stop')
#        ${BIN)DIR}/tcpclaim_signal.sh stop $PORT

;;
'status')
        /bin/netstat -na | grep $PORT
;;


*) 
	usage
;;

esac

exit 0
