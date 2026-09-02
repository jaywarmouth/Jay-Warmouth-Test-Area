#!/bin/sh

# Shell used to kill clmrt once memory is exceeded.
# This is hack to deal with RUNCOBOL memory leak in 12.16

# Reset threshold in KB
MAX_THRESHOLD="1097152"

# get process id
clmrt_pid=`ps -ef |grep "runcobol /usr/lnk/programs/obj/clmrt01 -s 00000010 -a 6867" | grep -v grep | awk '{ print $2 }'`


#get memory usage
memory_usage_kb=`pmap $clmrt_pid  | tail -1 | awk '{ print $2 }'`

# Trim off trailing "K"
memory_usage_kb=${memory_usage_kb%?}


if [ "$memory_usage_kb" -gt "$MAX_THRESHOLD" ]
then
date
echo "Memory usage at $memory_usage_kb KB"
echo "Terminating clmrt01 COBOL process id $clmrt_pid"
/usr/local/bin/clmrt01_kill.sh

fi
