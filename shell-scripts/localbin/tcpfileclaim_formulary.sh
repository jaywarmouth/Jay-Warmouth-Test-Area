#!/bin/sh
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

BIN_DIR=/usr/local/bin
LOG_DIR=/usr/local/logs/formulary
CONFIG_DIR=/usr/local/etc/formulary
SHELL_DIR=/usr/lnk/shell

#
# Main routine
#
SCRIPT_NAME="tcpfileclaim_formulary"
CONFIG_FILE="${CONFIG_DIR}/tcpfileclaim_formulary.cfg"
PORT="10125"
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

	RUNLINE="nohup ${BIN_DIR}/tcpfileclaim -f $CONFIG_FILE"
	su - ${RUN_AS} -c "${RUNLINE} | ${BIN_DIR}/logpipe -d -p ${ERR_FILE} 2>&1 &"

	sleep 3

	if [ -s "$ERR_FILE" ]
	then
		cat $ERR_FILE
	fi
;;

'stop')
        ${SHELL_DIR}/tcpclaim_signal.sh stop $PORT

;;
'pause_toggle')
        ${SHELL_DIR}/tcpclaim_signal.sh pause_toggle $PORT
;;
'clean_queues')
        ${SHELL_DIR}/tcpclaim_signal.sh clean $PORT
;;
'status')
        /bin/netstat -na | grep $PORT
;;


*) 
	usage
;;

esac

exit 0
