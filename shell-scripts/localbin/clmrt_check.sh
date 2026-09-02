#!/bin/sh

# Author: Steve Randlett
# Date: 2/8/2018
# Purpose:  Indicate if proper number of elgrt02 processes are running.
#	WUG integration

expected_processes="1"

count=`ps -ef|grep "runcobol /usr/lnk/programs/obj/clmrt01 -s 00000010 -a 6867 L=/usr/rmcobol/xmlif.so" | grep -v "grep" | wc -l`

log_date=`date "+%x %r"`

if [ "$count" -eq "$expected_processes" ]
then
	status="UP"
else
	status="DOWN"
fi

	echo "$log_date Status: $status Expected $expected_processes processes got $count processes" | /usr/local/bin/logpipe -d -p /tmp/.clmrt_check 2>&1

echo $status
