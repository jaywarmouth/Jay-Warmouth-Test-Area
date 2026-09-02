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

#
# Main routine
#
echo "THIS SHELL HAS BEEN DEPRECATED by queue2post"
exit 1

SCRIPT_NAME="tcpsendwebsrv_storm"
CONFIG_FILE="/usr/local/pub/tcpsendwebsrv_storm.cfg"
RUN_AS="c04"

CREATE_DATE=`date +%Y%m%d`
ERR_FILE="/tmp/.${SCRIPT_NAME}.${CREATE_DATE}.log"

# set -x


if [ "$#" -lt 1 ]
then
	usage
fi

ACTION="$1"

case "$ACTION" in
'start')

	RUNLINE="nohup /usr/local/bin/tcpsendwebsrv -f $CONFIG_FILE"
#	su - ${RUN_AS} -c "${RUNLINE} >${ERR_FILE} 2>&1 &"
	su - ${RUN_AS} -c "${RUNLINE} >>${ERR_FILE} 2>&1 "
#	su - ${RUN_AS} -c "${RUNLINE} 2>${ERR_FILE} >/dev/null &" 

	sleep 3

	if [ -s "$ERR_FILE" ]
	then
		cat $ERR_FILE
	fi
;;

'stop')
        /usr/pdm/shell/tcpclaim_signal.sh stop $PORT

;;
'pause_toggle')
        /usr/pdm/shell/tcpclaim_signal.sh pause_toggle $PORT
;;
'clean_queues')
        /usr/pdm/shell/tcpclaim_signal.sh clean $PORT
;;
'status')
        /usr/bin/netstat -na | grep $PORT
;;


*) 
	usage
;;

esac

exit 0
