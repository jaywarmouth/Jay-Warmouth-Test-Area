#!/bin/ksh
#
# Program Name	: webclaim_devl.sh
# Description	: Run daemon to receive claims via TCP
# Author	: Linda S. Jefferis
# Date		: 3/31/2017
# Modifications :
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: ${SCRIPT_NAME}.sh start|stop|pause_toggle PORT CONFIG_FILE

ENDOFUSAGE
  exit 1
}

#
# Main routine
#
#set -x
SCRIPT_NAME="webclaim_devl"
RUN_AS="c04"

ERR_FILE="/tmp/.${SCRIPT_NAME}.out"

# set -x

if [ "$#" -lt 1 ]
then
	usage
fi

ACTION="$1"
PORT="$2"
CONFIG_FILE="$3"

case "$ACTION" in
'start')

	RUNLINE="nohup /usr/local/bin/tcpclaim -f $CONFIG_FILE"
	su - ${RUN_AS} -c "${RUNLINE} 2>${ERR_FILE} >/dev/null &" 

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
        /usr/pdm/shell/tcpclaim_signal.sh clean $PORT
;;
'status')
        /bin/netstat -na | grep $PORT
;;


*) 
	usage
;;

esac

exit 0
