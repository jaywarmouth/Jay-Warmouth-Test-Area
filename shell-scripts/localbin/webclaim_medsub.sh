#!/bin/sh
#
# Program Name	: webclaim.sh
# Description	: Run daemon to recieve claims via TCP
# Author	: Steven Randlett
# Date		: 2-26-03
# Modifications :
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ${SCRIPT_NAME}.sh start|stop|pause_toggle

ENDOFUSAGE
  exit 1
}

BIN_DIR=/usr/local/bin
LOG_DIR=/usr/local/logs/linedrv/webclaim
CONFIG_DIR=/usr/local/etc/claimprocessing
SHELL_DIR=/usr/lnk/shell

#
# Main routine
#
#set -x
SCRIPT_NAME="webclaim_medsub"
PORT="10408"
CONFIG_FILE="${CONFIG_DIR}/webclaim_medsub.cfg"
RUN_AS="pdmisvc"

ERR_FILE="${LOG_DIR}/${SCRIPT_NAME}_errorlog"

# set -x

if [ "$#" -lt 1 ]
then
	usage
fi

ACTION="$1"

case "$ACTION" in
'start')

	RUNLINE="nohup ${BIN_DIR}/tcpclaim -f $CONFIG_FILE"
	su - ${RUN_AS} -c "${RUNLINE} 2>${ERR_FILE} >/dev/null &" 

	sleep 3

	if [ -s "$ERR_FILE" ]
	then
		cat $ERR_FILE
	fi
;;

'stop')
        ${BIN_DIR}/tcpclaim_signal.sh stop $PORT

;;
'pause_toggle')
        ${BIN_DIR}/tcpclaim_signal.sh pause_toggle $PORT
;;
'clean_queues')
        ${BIN_DIR}/tcpclaim_signal.sh clean $PORT
;;
'status')
        /bin/netstat -na | grep $PORT
;;


*) 
	usage
;;

esac

exit 0
