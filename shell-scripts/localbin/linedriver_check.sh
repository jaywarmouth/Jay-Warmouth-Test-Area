#!/bin/sh

#       Name: linedriver_check.sh
#       By  : Steven Randlett
#       Date: 2/3/2018
#       Purpose:
#  		Check to be sure linedrivers are up and running.
#		Intended to integrate with WUG
#
#
#

usage()
{
echo "$0 sw16|sw40 OH|NC"
exit 1

}

line_to_check="$1"
location="$2"

case "$line_to_check" in

	sw40) 
		port="10300"
		;;
	sw16)
		port="10200"
		;;
	*)
		usage
	;;
esac	

case "$location" in

	OH) 
		location_filter="172.16.100.163|172.16.101.30"
		;;
	NC)
		location_filter="172.16.110.26|172.16.110.215"
		;;
	*)
		usage
	;;
esac	

count=`netstat -na | grep $port | grep ESTABLISHED | egrep "$location_filter" | grep -v "LISTEN" |  wc -l`

if [ "$count" -eq "0" ]
then
# Added code to try to reduce false positivies from netstat
# anomolies
	sleep 3
	count=`netstat -na | grep $port | grep ESTABLISHED | egrep "$location_filter" | grep -v "LISTEN" |  wc -l`
fi

log_date=`date "+%x %r"`

if [ "$count" -gt "0" ]
then
	status="UP"
else
	status="DOWN"
fi

        echo "$log_date Line: $line_to_check  Location: $location Status: $status Line Count: $count" | /usr/local/bin/logpipe -d -p /tmp/.linedriver_check 2>&1




echo $status

exit 0
