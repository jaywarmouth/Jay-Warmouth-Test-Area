#!/bin/bash


OUTPUT_PATH="/tmp/systemstats"
WAIT_TIME="3"
INTERNET_TARGET="8.8.8.8"
INTRANET_TARGET="`/sbin/ip route show | head -1 | awk '{ print $3 }'`"

OIFS="$IFS"
CR="
"

#set -x


usage()
{
	echo "$0"
	exit 1
}


generate_guid()
{
uuidgen -r
}


generate_filename()
{
timestamp=`date +%s.%N`
NEW_UUID=$(uuidgen | fold -w 32)
randomid=${NEW_UUID:0:5}

fn="systemstats.${timestamp}.${randomid}"
echo -n $fn
}


get_established_connections()
{
connections=`netstat -na | grep "ESTABLISHED" | wc -l`
echo -n "\"establishedConnections\":$connections"
}
get_closewait_connections()
{
connections=`netstat -na | grep "CLOSE_WAIT" | wc -l`
echo -n "\"closeWaitConnections\":$connections"
}

get_timewait_connections()
{
connections=`netstat -na | grep "TIME_WAIT" | wc -l`
echo -n "\"timeWaitConnections\":$connections"
}



get_network_info()
{

first_time="1"

output="\"network\": {"

output="${output}`get_internet_latency`,"
output="${output}`get_intranet_latency`,"
output="${output}`get_established_connections`,"
output="${output}`get_closewait_connections`,"
output="${output}`get_timewait_connections`,"
output="${output}\"interfaces\":["

IFS="$CR"
	for line in `netstat -i | tail -n +3`
	do
		IFS="$OIFS"
		interface="`echo $line | cut -d " " -f 1`"
		if [ "$interface" == "lo" ]
		then
			continue
		fi	

		if [ "$first_time" -eq "0" ]
		then
			output="${output},"
		else
			first_time="0"
		fi
		received_packets="`echo $line | cut -d " " -f 4`"
		received_errors="`echo $line | cut -d " " -f 5`"
		received_dropped="`echo $line | cut -d " " -f 6`"
		transmit_packets="`echo $line | cut -d " " -f 8`"
		transmit_errors="`echo $line | cut -d " " -f 9`"
		transmit_dropped="`echo $line | cut -d " " -f 10`"

		output="${output}{"
		output="${output}\"interface\":\"$interface\","
		output="${output}\"receivedPackets\":$received_packets,"
		output="${output}\"receivedErrors\":$received_errors,"
		output="${output}\"receivedDropped\":$received_dropped,"
		output="${output}\"transmitPackets\":$transmit_packets,"
		output="${output}\"transmitErrors\":$transmit_errors,"
		output="${output}\"transmitDropped\":$transmit_dropped"

		output="${output}}"
		
		IFS="$CR"
	done
	output="${output}]}"

echo $output

}

get_disk_info()
{

first_time="1"

output="\"disk\": ["

IFS="$CR"
	for line in `df -B M --local |grep -v "/run/user/" | tail -n +2`
	do
		IFS="$OIFS"
		if [ "$first_time" -eq "0" ]
		then
			output="${output},"
		else
			first_time="0"
		fi
		available="`echo $line | cut -d " " -f 4`"
		available="${available%?}"
		used="`echo $line | cut -d " " -f 3`"
		used="${used%?}"
		directory="`echo $line | cut -d " " -f 6`"

		output="${output}{"
		output="${output}\"directory\":\"$directory\","
		output="${output}\"available\":$available,"
		output="${output}\"used\":$used"

		output="${output}}"
		


		IFS="$CR"
	done
	output="${output}]"

echo $output


}


get_internet_latency()
{
latency=`ping -W 2 -c 1 -n -q $INTERNET_TARGET | tail -1 | awk -F= '{ print $2 }'| awk -F/ '{ print $1 }'`

if [ "$latency" == "" ]
then
	latency="null"
fi

echo -n "\"internetLatency\":$latency"
}

get_intranet_latency()
{
latency=`ping -W 1 -c 1 -n -q $INTRANET_TARGET | tail -1 | awk -F= '{ print $2 }'| awk -F/ '{ print $1 }'`

if [ "$latency" == "" ]
then
	latency="null"
fi

echo -n "\"intranetLatency\":$latency"
}


# MAIN


while [ 1 ]
do
tmp_file="/tmp/`generate_filename`"

## Get CPU usage
sar_info=`sar 1 1 | tail -1` 
cpu_usage=`echo $sar_info | cut -d " " -f 8`
cpu_usage="`echo "scale=4;(100 - $cpu_usage)/100" | bc`"
cpu_usage=`printf "%.4f" $cpu_usage`

## Get I/O Wait percent
io_wait=`echo $sar_info |  cut -d " " -f 6`
io_wait="`echo "scale=4;($io_wait)/100" | bc`"
io_wait=`printf "%.4f" $io_wait`

## Get numbeer  of processes
process_count=`ps -e| wc -l`


## Get active memory 
active_memory=`cat /proc/meminfo | grep "Active:" | awk '{ print $2 }'`
# Convert from KB to MB
active_memory=`echo "scale=0;($active_memory)/1024" | bc`

## Get total memory 
total_memory=`cat /proc/meminfo | grep "MemTotal:" | awk '{ print $2 }'`
# Convert from KB to MB
total_memory=`echo "scale=0;($total_memory)/1024" | bc`

## Get system name
system_name=`uname -n`

## Get Date/Time
system_date=`date --iso-8601="ns"`

## Get logged in user count

logged_in_users=`w | wc -l`

echo -n "{" >$tmp_file
echo -n "\"guid\":\"`generate_guid`\"," >>$tmp_file
echo -n "\"systemName\":\"$system_name\"," >>$tmp_file
echo -n "\"date\":\"$system_date\"," >>$tmp_file
echo -n "\"cpuUsage\":$cpu_usage," >>$tmp_file
echo -n "\"ioWait\":$io_wait," >>$tmp_file
echo -n "\"processCount\":$process_count," >>$tmp_file
echo -n "\"activeMemory\":$active_memory," >>$tmp_file
echo -n "\"totalMemory\":$total_memory," >>$tmp_file
echo -n "\"loggedInUsers\":$logged_in_users," >>$tmp_file

echo -n "`get_disk_info`," >>$tmp_file
echo -n "`get_network_info`" >>$tmp_file


echo -n "}" >>$tmp_file

#cat $tmp_file

#echo "CPU: $cpu_usage"
#echo "iowait: $io_wait"
#echo "process count: $process_count"
#echo "active memory: $active_memory"
#echo "active memory: $active_memory"

mv $tmp_file $OUTPUT_PATH
sleep $WAIT_TIME
done

