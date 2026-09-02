#!/bin/sh

# Author: Steve Randlett
# Date: 2/3/2018
# Purpose:  Indicate if proper number of traffics are running.
#	WUG integration

expected_processes="8"

count=`ps -ef|grep "runcobol /usr/lnk/programs/obj/traffic02 -C /opt/rmcobol/terminfo-d0.cfg" | grep -v "grep" | wc -l`

log_date=`date "+%x %r"`

if [ "$count" -eq "$expected_processes" ]
then
	status="UP"
else
	status="DOWN"
fi

	echo "$log_date Status: $status Expected $expected_processes processes got $count processes" | /usr/local/bin/logpipe -d -p /tmp/.traffic_check 2>&1

echo $status
