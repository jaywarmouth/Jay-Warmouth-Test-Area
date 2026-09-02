#!/bin/sh

# Kill cobol clmrt01 process

clmrt_pid=`ps -ef |grep "runcobol /usr/lnk/programs/obj/clmrt01 -s 00000010 -a 6867" | grep -v grep | awk '{ print $2 }'`

if [ "$clmrt_pid" -gt "1" ]
then
	kill $clmrt_pid
else
	echo "Invalid process id \"$clmrt_pid\""
	exit 1
fi

exit 0

