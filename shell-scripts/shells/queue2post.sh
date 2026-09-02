#!/bin/ksh
#
# Program Name	: queue2post.sh
# Description	: Run daemon to recieve claims via TCP
# Author	: Steven Randlett
# Date		: 12/4/2015
# Modifications :
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: queue2post.sh config_file log_file

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

if [ "$#" -lt 2 ]
then
	usage
fi

CONFIG_FILE="$1"
ERR_FILE="$2"

RUN_AS="c04"

CREATE_DATE=`date +%Y%m%d`

# set -x

while [ 1 ]
do

	RUNLINE="nohup /usr/local/bin/queue2post -r $CONFIG_FILE"
#	su - ${RUN_AS} -c "${RUNLINE} >${ERR_FILE} 2>&1 &"
#	su - ${RUN_AS} -c "${RUNLINE} | /usr/local/bin/logpipe -d -p ${ERR_FILE} 2>&1 "
	su - ${RUN_AS} -c "${RUNLINE} | /usr/local/bin/logpipe -d -p ${ERR_FILE} 2>&1 "
#	su - ${RUN_AS} -c "${RUNLINE} 2>${ERR_FILE} >/dev/null &" 

	echo "Service died. Waiting"
	sleep 60
	echo "Service starting"


done

exit 0
